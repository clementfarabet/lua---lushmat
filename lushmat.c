// To load this lib in LUA:
// require 'liblushmat'

#include <luaT.h>
#include <TH/TH.h>

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int fillIntTensor(lua_State *L) {
  // tensor to fill:
  THIntTensor *tofill = luaT_checkudata(L, 1, luaT_checktypename2id(L, "torch.IntTensor"));
  // source storage:
  THByteStorage *toget = luaT_checkudata(L, 2, luaT_checktypename2id(L, "torch.ByteStorage"));
  // optional pointer:
  int pointer = 0;
  if (lua_isnumber(L, 3)) pointer = lua_tonumber(L, 3) - 1;
  // char pointers:
  unsigned char *src = (unsigned char *)toget->data;
  unsigned char *dest = (unsigned char *)THLongTensor_data(tofill);
  long int size = tofill->storage->size * sizeof(int);
  // fill:
  memcpy(dest, src+pointer, size);
  return 0;
}

int fillLongTensor(lua_State *L) {
  // tensor to fill:
  THLongTensor *tofill = luaT_checkudata(L, 1, luaT_checktypename2id(L, "torch.LongTensor"));
  // source storage:
  THByteStorage *toget = luaT_checkudata(L, 2, luaT_checktypename2id(L, "torch.ByteStorage"));
  // optional pointer:
  int pointer = 0;
  if (lua_isnumber(L, 3)) pointer = lua_tonumber(L, 3) - 1;
  // char pointers:
  unsigned char *src = (unsigned char *)toget->data;
  unsigned char *dest = (unsigned char *)THLongTensor_data(tofill);
  long int size = tofill->storage->size * sizeof(long);
  // fill:
  memcpy(dest, src+pointer, size);
  return 0;
}

int fillByteTensor(lua_State *L) {
  // tensor to fill:
  THByteTensor *tofill = luaT_checkudata(L, 1, luaT_checktypename2id(L, "torch.ByteTensor"));
  // source storage:
  THByteStorage *toget = luaT_checkudata(L, 2, luaT_checktypename2id(L, "torch.ByteStorage"));
  // optional pointer:
  int pointer = 0;
  if (lua_isnumber(L, 3)) pointer = lua_tonumber(L, 3) - 1;
  // char pointers:
  unsigned char *src = (unsigned char *)toget->data;
  unsigned char *dest = (unsigned char *)tofill->storage->data;
  long int size = tofill->storage->size * sizeof(unsigned char);
  // fill:
  memcpy(dest, src+pointer, size);
  return 0;
}

int fillFloatTensor(lua_State *L) {
  // tensor to fill:
  THFloatTensor *tofill = luaT_checkudata(L, 1, luaT_checktypename2id(L, "torch.FloatTensor"));
  // source storage:
  THByteStorage *toget = luaT_checkudata(L, 2, luaT_checktypename2id(L, "torch.ByteStorage"));
  // optional pointer:
  int pointer = 0;
  if (lua_isnumber(L, 3)) pointer = lua_tonumber(L, 3) - 1;
  // char pointers:
  unsigned char *src = (unsigned char *)toget->data;
  unsigned char *dest = (unsigned char *)tofill->storage->data;
  long int size = tofill->storage->size * sizeof(float);
  // fill:
  memcpy(dest, src+pointer, size);
  return 0;
}

int fillDoubleTensor(lua_State *L) {
  // tensor to fill:
  THDoubleTensor *tofill = luaT_checkudata(L, 1, luaT_checktypename2id(L, "torch.DoubleTensor"));
  // source storage:
  THByteStorage *toget = luaT_checkudata(L, 2, luaT_checktypename2id(L, "torch.ByteStorage"));
  // optional pointer:
  int pointer = 0;
  if (lua_isnumber(L, 3)) pointer = lua_tonumber(L, 3) - 1;
  // char pointers:
  unsigned char *src = (unsigned char *)toget->data;
  unsigned char *dest = (unsigned char *)tofill->storage->data;
  long int size = tofill->storage->size * sizeof(double);
  // fill:
  memcpy(dest, src+pointer, size);
  return 0;
}

// Register functions in LUA
static const struct luaL_reg matlab [] = {
  {"fillDoubleTensor", fillDoubleTensor},
  {"fillFloatTensor", fillFloatTensor},
  {"fillIntTensor", fillIntTensor},
  {"fillLongTensor", fillLongTensor},
  {"fillByteTensor", fillByteTensor},
  {NULL, NULL}  /* sentinel */
};

int luaopen_liblushmat (lua_State *L) {
  luaL_openlib(L, "liblushmat", matlab, 0);
  return 1;
}
