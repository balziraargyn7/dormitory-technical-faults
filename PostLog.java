public class PostLog {
    private Post[] items = new Post[30];
    private int count = 0;

    // Жаңа жазба қосады. Массив толса, false қайтарады.
    public boolean addRecord(String newDate, String newPlatform, int newViews, int newLikes) {
        if (count >= 30) {
            return false;
        }
        Post post = new Post();
        post.setDate(newDate);
        post.setPlatform(newPlatform);
        post.setViews(newViews);
        post.setLikes(newLikes);
        items[count] = post;
        count = count + 1;
        return true;
    }

    public int getCount() {
        return count;
    }

    // Барлық қаралымдардың қосындысы
    public int getTotal() {
        int sum = 0;
        int i = 0;
        while (i < count) {
            sum = sum + items[i].getViews();
            i = i + 1;
        }
        return sum;
    }

    // Орташа қаралым (бүтін бөлу)
    public int getAverage() {
        if (count == 0) {
            return 0;
        }
        return getTotal() / count;
    }

    // Қаралымы ең көп жазбаны табады
    public Post findMax() {
        if (count == 0) {
            return null;
        }
        Post max = items[0];
        int i = 1;
        while (i < count) {
            if (items[i].getViews() > max.getViews()) {
                max = items[i];
            }
            i = i + 1;
        }
        return max;
    }

    // Ереже бойынша (isPopular) сәйкес жазбалар саны
    public int countMatches() {
        int found = 0;
        int i = 0;
        while (i < count) {
            if (items[i].isPopular()) {
                found = found + 1;
            }
            i = i + 1;
        }
        return found;
    }

    public void printAll() {
        int i = 0;
        while (i < count) {
            System.out.print((i + 1) + ". ");
            items[i].printInfo();
            i = i + 1;
        }
    }

    // Платформа бойынша сүзу
    public void printByCategory(String value) {
        int found = 0;
        int i = 0;
        while (i < count) {
            if (items[i].getPlatform().equals(value)) {
                items[i].printInfo();
                found = found + 1;
            }
            i = i + 1;
        }
        if (found == 0) {
            System.out.println("Мұндай жазба табылмады");
        }
    }
}
