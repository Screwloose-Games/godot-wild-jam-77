---
name: Game Jam Task
about: Template for game jam-related tasks
title: "[Game Jam Task] "
labels: game-jam
assignees: 
body:
  - type: markdown
    attributes:
      value: |
        ### Prepopulated Text
        Use this template to document your game jam task.

        - **Reminder**: Stick to your game jam theme!
        - **Include Details**: Clearly outline the steps needed to complete this task.

        Below is the form to fill out:
  - type: input
    id: task-title
    attributes:
      label: Task Title
      description: Provide a short title for the task.
      placeholder: e.g., Create player character movement
  - type: textarea
    id: task-description
    attributes:
      label: Task Description
      description: Provide a detailed description of the task.
      placeholder: Describe what needs to be done.
  - type: dropdown
    id: task-priority
    attributes:
      label: Priority
      description: Select the priority level of the task.
      options:
        - Low
        - Medium
        - High
  - type: date
    id: due-date
    attributes:
      label: Due Date
      description: Select the due date for this task.
---

### Additional Prepopulated Content
Include any other context or notes here.
