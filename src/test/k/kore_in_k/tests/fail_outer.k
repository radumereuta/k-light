// should fail during outer parsing

module TEST
  syntax Exp{{}} ::= Exp{} "+" Exp{} [symbol(plus{})]
endmodule
