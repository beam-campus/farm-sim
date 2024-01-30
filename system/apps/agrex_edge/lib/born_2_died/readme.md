# Agrex.Born2Died Subsystem

The Agrex.Born2Died subsystem is responsible for controlling and simulating the life of farm animal.

## Outline

- [Agrex.Born2Died Subsystem](#agrexborn2died-subsystem)
  - [Outline](#outline)
  - [Actor diagram](#actor-diagram)
  - [Sequence diagram](#sequence-diagram)

## Actor diagram

```mermaid
graph TD

  System[Agrex.Born2Died.System]
  Supervisor[Agrex.Born2Died.System.Supervisor]
  Worker[Agrex.Born2Died.Worker]
  Channel[Agrex.Born2Died.Channel]

  System --> |start_link| Supervisor  
  Supervisor --> |start_child| Worker
  Supervisor --> |start_child| Channel

```

## Sequence diagram

```mermaid
sequenceDiagram
  participant Life.System
  participant Life.Supervisor
  participant Life.Worker
  participant Life.Channel

  Life.System->>Life.Supervisor : start_link(life_id)

```
