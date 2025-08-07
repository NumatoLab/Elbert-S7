# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\projects\\Elbert_S7\\SD_card\\viti_unified\\SD_test\\microblaze_0\\standalone_microblaze_0\\bsp\\include\\sleep.h"
  "C:\\projects\\Elbert_S7\\SD_card\\viti_unified\\SD_test\\microblaze_0\\standalone_microblaze_0\\bsp\\include\\xiltimer.h"
  "C:\\projects\\Elbert_S7\\SD_card\\viti_unified\\SD_test\\microblaze_0\\standalone_microblaze_0\\bsp\\include\\xtimer_config.h"
  "C:\\projects\\Elbert_S7\\SD_card\\viti_unified\\SD_test\\microblaze_0\\standalone_microblaze_0\\bsp\\lib\\libxiltimer.a"
  )
endif()
