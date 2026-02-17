import java.util.List;

public interface GuestDAO extends BaseDAO<Guest> {
    List<Guest> searchGuests(String query);
}
