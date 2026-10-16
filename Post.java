public class Post {
    private String date;      // күні, мысалы "10.10"
    private String platform;  // платформа: Instagram, TikTok
    private int views;        // қаралым саны
    private int likes;        // лайк саны

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        if (date.equals("")) {
            System.out.println("Қате: күн бос болмауы керек");
        } else {
            this.date = date;
        }
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        if (platform.equals("")) {
            System.out.println("Қате: платформа бос болмауы керек");
        } else {
            this.platform = platform;
        }
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        if (views < 1 || views > 10000000) {
            System.out.println("Қате: қаралым 1..10000000 аралығында болуы керек");
        } else {
            this.views = views;
        }
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        if (likes < 0 || likes > 10000000) {
            System.out.println("Қате: лайк 0..10000000 аралығында болуы керек");
        } else {
            this.likes = likes;
        }
    }

    // Ереже: лайк саны қаралымның кемінде 10%-ы болса, пост танымал
    public boolean isPopular() {
        if (views == 0) {
            return false;   // 0-ге бөлмеу үшін
        }
        return likes * 100 / views >= 10;
    }

    // Жазбаны бір жолға шығару
    public void printInfo() {
        System.out.println(date + " | " + platform + " | " + views + " қаралым | лайк: " + likes);
    }
}
