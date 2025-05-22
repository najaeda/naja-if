# naja-if

![Ubuntu Build](https://github.com/najaeda/naja-if/actions/workflows/ubuntu-cpp-build.yml/badge.svg)
![MacOS Build](https://github.com/najaeda/naja-if/actions/workflows/macos-cpp-build.yml/badge.svg)

## Introduction

Naja-if is a Cap'n Proto for EDA netlist data serialization and streaming.

Files composing the dump are created in a directory usually named "snl", composed of the following files:

Manifest File (snl.mf): This file encapsulates essential meta-information such as the schema version and other relevant details.
Interface Definition File (db_interface.snl): This file outlines the interfaces of modules: terminals and parameters.
Implementation Specification File (db_implementation.snl): Contained within this file are the detailed implementations of modules: instances, nets and connectivity between them.
Naja interchange files can be examined using the capnp tool.

capnp decode --packed snl_interface.capnp DBInterface < snl/db_interface.snl > interface.txt
capnp decode --packed snl_implementation.capnp DBImplementation < snl/db_implementation.snl > implementation.txt
