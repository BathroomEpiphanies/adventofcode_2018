import java.io.BufferedReader;
import java.io.InputStreamReader;

public class solution {
  private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
  
  private static long[] game(int N, int M) {
    long[] score = new long[N+1];
    
    Ring ring = new Ring();
    
    for (int i=1; i<=M; i++) {
      if(i%23==0) {
        score[i%N+1] += i;
        ring.shift_left(7);
        score[i%N+1] += ring.delete();
        continue;
      }
      ring.shift_right(1);
      ring.insert(i);
    }
    //ring.print();
    return score;
  }
    
  public static void main(String[] args) throws Exception {
    while(reader.ready()) {
      String[] tokens = reader.readLine().split("\\s+");
      int N = Integer.parseInt(tokens[0]);
      int M = Integer.parseInt(tokens[6]);
      System.out.printf("%d %d\n", N, M);
      
      long[] score = game(N, M);
      long max = 0;
      for(int i=1; i<=N; i++)
        if(score[i]>max)
          max = score[i];
      System.out.printf("Max score: %d\n",max);
      
    }
    
  }
  
  
  private static class Ring {
    private Marble first;
    private Marble current;
    
    private class Marble {
      public int val;
      public Marble prev;
      public Marble next;
      
      public Marble(int val) {
        this.val = val;
      }
    }
    
    public Ring() {
      this.first = this.current = new Marble(0);
      current.next = current.prev = first;
    }
    
    public void shift_right(int steps) {
      for (int i=0; i<steps; i++)
        current = current.next;
    }
    public void shift_left(int steps) {
      for (int i=0; i<steps; i++)
        current = current.prev;
    }
    
    public void insert(int val) {
      Marble insert = new Marble(val);
      insert.prev = current;
      insert.next = current.next;
      insert.next.prev = insert;
      current.next = insert;
      current = insert;
    }
    
    public int delete() {
      int res = current.val;
      current.prev.next = current.next;
      current.next.prev = current.prev;
      current = current.next;
      return res;
    }
    
    public int get_current() {
      return current.val;
    }
    
    public void print() {
      Marble first = this.first;
      Marble current = first;
      do {
        System.out.printf("%d ", current.val);
        current = current.next;
      } while(current != first);
      System.out.printf("\n");
    }
    
  }
}
