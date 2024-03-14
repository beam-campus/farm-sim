# Agrex.Region Subsystem

## Abstract

The Agrex.Region Subsystem is responsible for generating a virtual region in the Agrex Landscape.

A Agrex.Region is identified by an *InitParams.id* and consists of a number of farms, determined by the *InitParams.nbr_of_farms* value.

## **Diagrams**

### Components

```mermaid  
graph TD;
    A(Agrex.Region.System) -->|supervise| B(Agrex.Region.Builder)
    A -->|supervise| C(Agrex.Region.Farms)
    C -->|start| D(Agrex.MngFarm.System 0)
    C -->|start| E(Agrex.MngFarm.System N-1)
    style A fill: #34f, stroke: #333, stroke-width: 4px 
    style B fill: #34f, stroke: #333, stroke-width: 4px, stroke-dasharray: 5,5
    style C fill: #34f, stroke: #333, stroke-width: 4px, stroke-dasharray: 5,5
    style D fill: #a4f, stroke: #333, stroke-width: 4px, stroke-dasharray: 5,5
    style E fill: #a4f, stroke: #333, stroke-width: 4px, stroke-dasharray: 5,5

```

### Sequence
