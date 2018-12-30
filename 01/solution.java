import java.util.HashSet;
import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;


public class solution {
  
  private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
  
  public static void main(String[] args) throws IOException {
    ArrayList<Integer> change = new ArrayList<Integer>();
    String line;
    while ((line = reader.readLine()) != null)
      change.add(Integer.parseInt(line));
    
    HashSet<Integer> seen = new HashSet<Integer>();
    int frequency = 0;
    int round = 1;
    boolean found = false;
    while(!found) {
      for(int i = 0; i < change.size(); i++) {
        frequency += change.get(i);
        if(!found && seen.contains(frequency)) {
          System.out.printf("Found duplicate: %d on round %d\n", frequency, round);
          found = true;
        }
        else {
          seen.add(frequency);
        }
      }
      if(round == 1)
        System.out.printf("Frequency after round %d: %d\n", round, frequency);
      round++;
    }
  }
}
