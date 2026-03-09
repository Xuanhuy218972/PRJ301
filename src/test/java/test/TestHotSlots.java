package test;

import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.model.HotSlotDTO;
import java.util.List;

public class TestHotSlots {
    public static void main(String[] args) {
        System.out.println("Testing getHotSlots()...");
        FieldSlotDAO dao = new FieldSlotDAO();
        try {
            List<HotSlotDTO> slots = dao.getHotSlots();
            System.out.println("Result count: " + slots.size());
            for (HotSlotDTO slot : slots) {
                System.out.println(slot.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
