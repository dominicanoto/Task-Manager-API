package com.example.taskmanager;

import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
public class TaskController {

    private final List<Map<String, Object>> tasks = new ArrayList<>();
    private int nextId = 1;

    public TaskController() {
        tasks.add(Map.of("id", nextId++, "title", "Вивчити Docker"));
        tasks.add(Map.of("id", nextId++, "title", "Створити REST API"));
    }

    @GetMapping("/")
    public String home() {
        return "Task Manager API працює!";
    }

    @GetMapping("/tasks")
    public synchronized List<Map<String, Object>> getTasks() {
        return List.copyOf(tasks);
    }

    @PostMapping("/tasks")
    public synchronized Map<String, Object> addTask(@RequestBody Map<String, String> data) {
        String title = data.get("title");

        if (title == null || title.isBlank()) {
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    "Назва задачі обов'язкова"
            );
        }

        Map<String, Object> task = Map.of(
                "id", nextId++,
                "title", title
        );

        tasks.add(task);
        return task;
    }

    @DeleteMapping("/tasks/{id}")
    public synchronized String deleteTask(@PathVariable int id) {
        boolean removed = tasks.removeIf(
                task -> (int) task.get("id") == id
        );

        if (removed) {
            return "Задачу видалено";
        }

        return "Задачу не знайдено";
    }
}
