public class PostApp {
    public static void main(String[] args) {
        PostLog log = new PostLog();

        // Өз деректерім: Instagram посты, 10.10-14.10
        log.addRecord("10.10", "Instagram", 1904, 122);
        log.addRecord("11.10", "Instagram", 1904, 124);
        log.addRecord("12.10", "Instagram", 1905, 126);
        log.addRecord("13.10", "Instagram", 1907, 127);
        log.addRecord("14.10", "Instagram", 1908, 127);

        log.printAll();
    }
}
