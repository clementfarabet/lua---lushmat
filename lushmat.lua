----------------------------------------------------------------------
--
-- Copyright (c) 2011 Clement Farabet
-- 
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- 
----------------------------------------------------------------------
-- description:
--     lushmat - a simple converter btwn lush's matrix <> torch tensor
--
-- history: 
--     December  2, 2011, 11:33AM - creation - Clement Farabet
----------------------------------------------------------------------

require 'torch'
require 'liblushmat'

------------------------------------------------------------
-- create package
--
lushmat = {}

-- load
function lushmat.load(idxfile)
   -- args
   local tensor = torch.Tensor()
   local binary = torch.ByteStorage(idxfile)
   local headerp = 1
   local swap = false

   -- helper function
   local function toint()
      local int = 0
      if swap then
         local shifter = 256*256*256
         for i = 1,4 do
            int = int + shifter*binary[headerp]
            shifter = shifter/256
            headerp = headerp+1
         end
      else
         local shifter = 1
         for i = 1,4 do
            int = int + shifter*binary[headerp]
            shifter = shifter*256
            headerp = headerp+1
         end
      end
      return int
   end

   -- get header:
   local magic = toint()
   if binary[1] == 0 then
      swap = true
      magic = binary[3]
   end
   local dims
   if swap then
      dims = binary[4]
   else
      dims = toint()
   end
   local tensorSize = torch.LongStorage(dims)
   for i = 1,dims do
      tensorSize[i] = toint()
   end

   -- load data
   local result
   if magic == 507333713 or magic == 0x0D then
      result = torch.FloatTensor(tensorSize)
      liblushmat.fillFloatTensor(result, binary, headerp)
   elseif magic == 507333715 or magic == 0x0E then
      result = torch.Tensor(tensorSize)
      liblushmat.fillDoubleTensor(result, binary, headerp)
   elseif magic == 50855936 or magic == 0x08 or magic == 0x09 then
      result = torch.ByteTensor(tensorSize)
      liblushmat.fillByteTensor(result, binary, headerp)
   elseif magic == 507333716 then
      result = torch.IntTensor(tensorSize)
      liblushmat.fillIntTensor(result, binary, headerp)
   elseif magic == 507333720 then
      error('<lushmat.load> error: long is not supported')
   else
      error('<lushmat.load> error: unknown magic number = ' .. magic)
   end

   -- return loaded tensor
   return result
end

-- return package
return lushmat
