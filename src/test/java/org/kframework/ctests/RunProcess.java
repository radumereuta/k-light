package org.kframework.ctests;

import java.io.*;
import java.util.Map;
import java.util.function.Supplier;

// instantiate processes
public class RunProcess {

    /**
     * Returns a thread that pipes all incoming data from {@param in} to {@param out}.
     *
     * @param in  A function that returns the input stream to be piped to {@param out}
     * @param out The output stream to pipe data to.
     * @return A {@link Thread} that will pipe all data from {@param in} to {@param out} until EOF is reached.
     */
    private static Thread getOutputStreamThread(Supplier<InputStream> in, PrintStream out) {
        return new Thread(() -> {
            int count;
            byte[] buffer = new byte[8192];
            try {
                while (true) {
                    count = in.get().read(buffer);
                    if (count < 0)
                        break;
                    out.write(buffer, 0, count);
                }
            } catch (IOException e) {
            }
        });
    }

    public static class ProcessOutput {
        public final byte[] stdout;
        public final byte[] stderr;
        public final int exitCode;

        public ProcessOutput(byte[] stdout, byte[] stderr, int exitCode) {
            this.stdout = stdout;
            this.stderr = stderr;
            this.exitCode = exitCode;
        }
    }

    private RunProcess() {
    }

    public static ProcessOutput execute(Map<String, String> environment, File workingDir, String... commands) throws InterruptedException, IOException {

        if (commands.length <= 0) {
            throw new RuntimeException("Need command options to run");
        }

        ProcessBuilder pb = new ProcessBuilder().directory(workingDir).command(commands);
        // create process
        pb.environment().putAll(environment);


        // start process
        Process process = pb.start();

        ByteArrayOutputStream out, err;
        PrintStream outWriter, errWriter;
        out = new ByteArrayOutputStream();
        err = new ByteArrayOutputStream();
        outWriter = new PrintStream(out);
        errWriter = new PrintStream(err);

        Thread outThread = getOutputStreamThread(process::getInputStream, outWriter);
        Thread errThread = getOutputStreamThread(process::getErrorStream, errWriter);

        outThread.start();
        errThread.start();

        // wait for process to finish
        process.waitFor();

        outThread.join();
        errThread.join();
        outWriter.flush();
        errWriter.flush();

        return new ProcessOutput(out.toByteArray(), err.toByteArray(), process.exitValue());
    }
}
