package model;

import java.util.List;

public class Page<T> {
    private List<T> data;
    private int currentPage;
    private int totalPage;
    private int totalItem;

    public Page() {
    }

    public Page(List<T> data, int currentPage, int pageSize, int totalItem) {
        this.data = data;
        this.currentPage = currentPage;
        this.totalPage = (int) Math.ceil((double) totalItem/pageSize);
        this.totalItem = totalItem;
    }

    public List<T> getData() {
        return data;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getTotalItem() {
        return totalItem;
    }
}
