import java.io.BufferedReader;
import java.io.InputStreamReader;

public class solution {
  private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

    
  public static void main(String[] args) throws Exception {
    while(reader.ready()) {
      int N = Integer.parseInt(reader.readLine());
      Ring recipes = new Ring();
      recipes.current1 = recipes.push(3,null);
      recipes.current2 = recipes.push(7,recipes.current1);

      
      //String[] line = reader.readLine().split("");
      //int N = line.length;
      //Ring recipes = new Ring();
      //
	    //for (int i=0; i<N; i++) {
      //  recipes.current1 = recipes.push(Integer.parseInt(line[i]),recipes.current1);
      //}
      //recipes.print();
      //recipes.current1 = recipes.first;
      //recipes.current2 = recipes.current1.next;
      
      while (recipes.length < N+10) {
        int score = recipes.current1.val + recipes.current2.val;
        String[] line = (""+score).split("");
        for (int i=0; i<line.length; i++) {
          recipes.push(Integer.parseInt(line[i]), recipes.first.prev);
        }
        recipes.current1 = recipes.shift_right(1+recipes.current1.val, recipes.current1);
        recipes.current2 = recipes.shift_right(1+recipes.current2.val, recipes.current2);
      }
      recipes.print();
      
    }
	
  }




  
    
  private static class Ring {
    public Item first;
    public int length;
    public Item current1;
    public Item current2;
	
    private class Item {
	    public int val;
	    public Item prev;
	    public Item next;
	    
	    public Item(int val) {
        this.val = val;
	    }
    }

    public Ring() {
	    //this.first = this.current = new Item(0);
	    current1 = current2 = null;
    }

    public Item shift_right(int steps, Item current) {
	    for (int i=0; i<steps; i++)
        current = current.next;
      return current;
    }
    public Item shift_left(int steps, Item current) {
	    for (int i=0; i<steps; i++)
        current = current.prev;
      return current;
    }

    public Item push(int val, Item current) {
	    Item push = new Item(val);
      if(current==null) {
        current = push;
        current.next = current;
        current.prev = current;
        this.first = current;
      }
	    push.prev = current;
	    push.next = current.next;
	    push.next.prev = push;
	    current.next = push;
	    current = push;
      this.length++;
      return push;
    }

    public int delete(Item current) {
	    int res = current.val;
	    current.prev.next = current.next;
	    current.next.prev = current.prev;
	    current = current.next;
      this.length--;
	    return res;
    }
	
    public void print() {
	    Item first = this.first;
	    Item current = first;
	    do {
        System.out.printf("%d ", current.val);
        current = current.next;
	    } while(current != first);
	    System.out.printf("\n");
    }
	
  }
}
