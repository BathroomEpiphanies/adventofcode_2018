import java.math.BigInteger;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class solution {
  
  private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

  private static BigInteger[] reg = new BigInteger[4];


  static private void oper (int op, int a, int b, int c) {
    if       (op ==  0) { reg[c] = reg[a];                                                                      }   // setr "00""08"
    else if  (op ==  1) { reg[c] = reg[a].compareTo(reg[b])>0? BigInteger.ONE: BigInteger.ZERO;                 }   // gtrr "01""12"
    else if  (op ==  2) { reg[c] = reg[a].add(reg[b]);                                                          }   // addr "02""00"
    else if  (op ==  3) { reg[c] = reg[a].and(new BigInteger(""+b));                                            }   // bani "03""05"
    else if  (op ==  4) { reg[c] = new BigInteger(""+a);                                                        }   // seti "04""09"
    else if  (op ==  5) { reg[c] = reg[a].or(new BigInteger(""+b));                                             }   // bori "05""07"
    else if  (op ==  6) { reg[c] = reg[a].or(reg[b]);                                                           }   // borr "06""06"
    else if  (op ==  7) { reg[c] = reg[a].equals(reg[b])? BigInteger.ONE: BigInteger.ZERO;                      }   // eqrr "07""15"
    else if  (op ==  8) { reg[c] = reg[a].multiply(reg[b]);                                                     }   // mulr "08""02"
    else if  (op ==  9) { reg[c] = reg[a].equals(new BigInteger(""+b))?  BigInteger.ONE: BigInteger.ZERO;       }   // eqri "09""14"
    else if  (op == 10) { reg[c] = reg[a].compareTo(new BigInteger(""+b))>0?   BigInteger.ONE: BigInteger.ZERO; }   // gtri "10""11"
    else if  (op == 11) { reg[c] = new BigInteger(""+a).equals(reg[b])?  BigInteger.ONE: BigInteger.ZERO;       }   // eqir "11""13"
    else if  (op == 12) { reg[c] = reg[a].and(reg[b]);                                                          }   // banr "12""04"
    else if  (op == 13) { reg[c] = new BigInteger(""+a).compareTo(reg[b])>0?  BigInteger.ONE: BigInteger.ZERO;  }   // gtir "13""10"
    else if  (op == 14) { reg[c] = reg[a].add(new BigInteger(""+b));                                            }   // addi "14""01"
    else if  (op == 15) { reg[c] = reg[a].multiply(new BigInteger(""+b));                                       }   // muli "15""03"

    return;
  }

  public static void main(String[] args) throws Exception {
    reg[0] = BigInteger.ZERO;
    reg[1] = BigInteger.ZERO;
    reg[2] = BigInteger.ZERO;
    reg[3] = BigInteger.ZERO;

    int i = 0;
    while(reader.ready()) {
      System.out.printf("% 5d % 5d % 5d % 5d % 5d", i++, reg[0].bitLength(), reg[1].bitLength(), reg[2].bitLength(), reg[3].bitLength());
      String[] op = reader.readLine().split("\\s+");
      System.out.printf("%s %s %s %s\n", op[0],op[1],op[2],op[3]);
      oper(Integer.parseInt(op[0]),Integer.parseInt(op[1]),Integer.parseInt(op[2]),Integer.parseInt(op[3]));
    }


    System.out.println(reg[0]);
    System.out.println(reg[1]);
    System.out.println(reg[2]);
    System.out.println(reg[3]);
    System.out.println();
  }
}
