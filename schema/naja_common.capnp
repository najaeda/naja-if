# SPDX-FileCopyrightText: 2023 The Naja authors <https://github.com/najaeda/naja/blob/main/AUTHORS>
#
# SPDX-License-Identifier: Apache-2.0

@0x8180e964216c1d8e;

struct DesignReference {
  dbID      @0 : UInt8;
  libraryID @1 : UInt16;
  designID  @2 : UInt32;
}

struct PropertyValue {
  union {
    text    @0 : Text;
    bool    @1 : Bool;
    uint64  @2 : UInt64;
  }
}

struct Property {
  name    @0 : Text;
  values  @1 : List(PropertyValue);
}

# RTL source metadata (see naja's SNLRTLInfos.h).
struct SourceLoc {
  file      @0 : Text;    # source file path
  line      @1 : UInt32;
  endLine   @2 : UInt32;
  column    @3 : UInt16;
  endColumn @4 : UInt16;
}

# One arbitrary extra key/value info.
struct RTLInfo {
  name  @0 : Text;
  value @1 : Text;
}

# Per-object RTL infos: an optional source location plus an optional
# set of extra key/value infos. sourceLoc is a pointer field, so it reads
# back null (hasSourceLoc() == false) when absent; infos is empty when none.
struct RTLInfos {
  sourceLoc @0 : SourceLoc;
  infos     @1 : List(RTLInfo);
}

# Width-exact four-state logic value. Bit zero is the least-significant bit;
# aval/bval use 00=0, 10=1, 11=X, 01=Z in little-endian 64-bit words.
struct LogicVector {
  width @0 : UInt64;
  aval  @1 : List(UInt64);
  bval  @2 : List(UInt64);
}
