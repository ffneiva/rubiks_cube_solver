# Rubik Cube Solver

## Motivation

This app is a Flutter implementation of a solver for the Rubik's Cube, developed as part of an extension project at the Federal University of Goiás (UFG). It uses the Kociemba algorithm to find a solution with a minimal number of moves, close to the God's number.

### Kociemba Algorithm

The Kociemba algorithm reduces the cube to a state that requires only double-layer moves except in two opposite layers, transforming the cube into a 3x3x2, and then solves the cube with a maximum of 29 moves.

### God's Number

The God's Number is a metric referring to the maximum number of moves needed to solve any configuration of the Rubik's Cube, regardless of how it's scrambled. Mathematical studies have shown that God's Number is 20.

## Usage
