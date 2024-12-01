## Color Picker

### Elm Learning Notes

- smallest building block is called a value, example- 4, true, "Hello"
- arrays are list here, lists need to have data of same type
  - some of the list methods are
    - List.isEmpty listName
    - List.length listName
    - List.reverse listName
    - List.sort listName
    - List.map funcName listName
- elm has tuples, tuples can store multiple values of multiple types
- elm has records, just like what objects are, only the syntax is a little different, instead of : we use = here to assign a value to record key
- functions are writtin like funcName param1 param2 instead of funcName(param1, param2)

- elm architecture
  - elm program -> html -> message (button clicked)
  - three major parts of a el program
    - model: state of the program
    - view: turns state into html
    - update: updates state based on message
  - main in elm is the entry point of the program
  - elm program takes in three functions
    - init: initializes the program
    - update: updates the state based on message
    - view: turns state into html
  - building helper functions is a common practice

Elm starts by rendering the initial value on screen. From there we enter into this loop:
(from elm docs)

- Wait for user input.
- Send a message to update
- Produce a new Model
- Call view to get new HTML
- Show the new HTML on screen
- Repeat!

## Lamdera Notes

- structure:
  - frontend.elm (client.ts)
  - backend.elm (server.ts)
  - types.elm (types.d.ts)
  - elm.json (elm package.json)
- need to send messages from frontend to backend, process is called wiring
- useful functions are
  - sendToBackend: to send message to backend
  - sendToFrontend: to send message to client
  - broadcast: to send message to all clients
  - onConnect: to run a function when a client connects
  - onDisconnect: to run a function when a client disconnects
