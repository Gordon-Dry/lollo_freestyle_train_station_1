package.path = package.path .. ';res/scripts/?.lua'

local arrayUtils = require('lollo_freestyle_train_station.arrayUtils')
local transfUtils = require('lollo_freestyle_train_station.transfUtils')
local aaa = { 1, 0, 0, 0,
0, 1, 0, 0,
0, 0, 1, 0,
10, 0, 0, 1}
local inverted = transfUtils.getInverseTransf(aaa)
-- the inverted matrix is 
local aaaInverted = { 1, 0, 0, 0,
0, 1, 0, 0,
0, 0, 1, 0,
-10, 0, 0, 1}

local edgeIds = {111, 222, 333, 444}
local edgeIdsReversed = arrayUtils.sort(edgeIds, nil, false)

local seed = math.randomseed(123)
local rnd = math.random(123, 999)

local root = 'aaa_'
local a2 = 'aaa_2'
local a3 = 'aaa_3'
local tail = string.gsub(a2, root, '')
local dummy = 123

--  id = 24148,
--  node0 = 25258,
--  node1 = 25261,

-- id = 24100,
--   node0 = 24592,
--   node1 = 25290,