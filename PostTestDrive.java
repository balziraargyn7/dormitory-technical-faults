public class PostTestDrive {
    public static void main(String[] args) {
        // ТЕСТ 1 және 2: сеттер қате мәнді қабылдамайды
        Post p = new Post();
        p.setViews(500);   // дұрыс мән

        p.setViews(20000000);
        if (p.getViews() == 500) {
            System.out.println("ТЕСТ 1 (жоғарғы шектен асқан мән қабылданбайды): OK");
        } else {
            System.out.println("ТЕСТ 1: ҚАТЕ");
        }

        p.setViews(0);
        if (p.getViews() == 500) {
            System.out.println("ТЕСТ 2 (төменгі шектен кем мән қабылданбайды): OK");
        } else {
            System.out.println("ТЕСТ 2: ҚАТЕ");
        }

        // Үш тест жазбасы (күтілетін мәндер қолмен есептелген):
        // 100 қаралым, 20 лайк -> 20% -> танымал
        // 300 қаралым, 15 лайк ->  5% -> танымал емес
        // 200 қаралым, 25 лайк -> 12% -> танымал
        PostLog log = new PostLog();
        log.addRecord("01.01", "Instagram", 100, 20);
        log.addRecord("02.01", "TikTok", 300, 15);
        log.addRecord("03.01", "Instagram", 200, 25);

        // ТЕСТ 3: қосынды 100 + 300 + 200 = 600
        if (log.getTotal() == 600) {
            System.out.println("ТЕСТ 3 (қосынды): OK");
        } else {
            System.out.println("ТЕСТ 3: ҚАТЕ");
        }

        // ТЕСТ 4: ең үлкен қаралым - екінші жазба (300, TikTok)
        Post max = log.findMax();
        if (max != null && max.getViews() == 300 && max.getPlatform().equals("TikTok")) {
            System.out.println("ТЕСТ 4 (ең үлкен мән): OK");
        } else {
            System.out.println("ТЕСТ 4: ҚАТЕ");
        }

        // ТЕСТ 5: ереже бойынша 2 жазба (1-ші және 3-ші)
        if (log.countMatches() == 2) {
            System.out.println("ТЕСТ 5 (ереже бойынша санау): OK");
        } else {
            System.out.println("ТЕСТ 5: ҚАТЕ");
        }
    }
}
