# AGREX - Farm Simulator

## ABSTRACT

This project sprouts from the idea to build a performance- and load testing tool  
that allows to spin up a number of virtual farms.
Each farm is an actor that generates a stream of events that are forwarded to ETL pipelines for further processing.  
Next, we'll leverage ES/CQRS to store the events in `EventStoreDB` and project into some DB, constructing views that support lighting-fast queries, using the excellent `commanded`  library. Visualization and User interaction will be done using Phoenix/LiveView.


### Some of the libraries used

![1704159811385](image/README/1704159811385.png)

## DISCLAIMER

This project is far from complete and some of the code in this repo may not always be idiomatic or optimal and should best be considered as a learning endeavor.  
The best way to get valuable experience is to build systems that present real-world challenges, right?

So let's get those hands dirty and make it work...and then **make it BEAUTIFUL!**

![1704170193545](image/README/1704170193545.png)


## OUTLINE

- [AGREX - Farm Simulator](#agrex---farm-simulator)
  - [ABSTRACT](#abstract)
    - [Some of the libraries used](#some-of-the-libraries-used)
  - [DISCLAIMER](#disclaimer)
  - [OUTLINE](#outline)
  - [PREREQUISITS](#prerequisits)
  - [GETTING STARTED](#getting-started)
    - [Running in interactive mode](#running-in-interactive-mode)
    - [Tinkering the settings](#tinkering-the-settings)
    - [Maybe you want to play around with scale?](#maybe-you-want-to-play-around-with-scale)

## PREREQUISITS

Make sure you have installed **Elixir**.
We recommend using `asdf` for this.  
Please check out the [Instructions](https://thinkingelixir.com/install-elixir-using-asdf/)

## GETTING STARTED

### Running in interactive mode

```bash
git clone https://github.com/beam-campus/farm-sim.git
cd farm-sim/system/apps/agrex_edge
iex -S mix

```

### Tinkering the settings

### Maybe you want to play around with scale?

- :bulb: Checkout the `agrex/lib/limits.ex` file...
- Please keep in mind that Erlang/OTP was built for scalability.
- If you feel the need to live dangerously, be my guest.  
Nothing _should_ catch on fire... :smirk:

![1704159523977](image/README/1704159523977.png)
