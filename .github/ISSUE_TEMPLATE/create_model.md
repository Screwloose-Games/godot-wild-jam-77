name: Create 3D Model for Game Object
description: Template for creating a new 3D model for a game object.
title: "Create 3D model for {{game object name}}"
labels:
  - 3D model
body:
  - type: textarea
    id: description
    attributes:
      label: Description
      description: Provide a description of the game object model to be created.
      placeholder: "Enter the model description..."
    validations:
      required: true

  - type: input
    id: file_path
    attributes:
      label: Save File Path
      description: Provide the full filepath where the model should be saved.
      placeholder: "Enter the full file path..."
    validations:
      required: true

  - type: markdown
    attributes:
      value: |
        ## Acceptance Criteria:

        - [ ] The model is saved in `.gltf` file format.
        - [ ] The model is saved to the specified filepath: `{{file_path}}`.
        - [ ] The model is opened in Godot to generate the `.import` file.
        - [ ] The file has been imported in godot (Godot opened) and has the accompanying `.import` file.
        - [ ] A pull request (PR) is created with the changes.
---

## Acceptance Criteria:

- [ ] The model is saved in `.gltf` file format.
- [ ] The model is saved to the specified filepath: `{{file_path}}`.
- [ ] The model is opened in Godot to generate the `.import` file.
- [ ] The file has been imported in godot (Godot opened) and has the accompanying `.import` file.
- [ ] A pull request (PR) is created with the changes.