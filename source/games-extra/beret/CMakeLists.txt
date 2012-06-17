cmake_minimum_required (VERSION 2.8)
project (Beret)

add_executable(beret game.c thing.c physics.c)

find_package(SDL)
if (SDL_FOUND)
    include_directories(${SDL_INCLUDE_DIR})
    target_link_libraries (beret ${SDL_LIBRARY})
else ()
    message(FATAL_ERROR "SDL not found")
endif ()

find_package(SDL_image)
if (SDLIMAGE_FOUND)
    target_link_libraries (beret ${SDLIMAGE_LIBRARY})
else ()
    message(FATAL_ERROR "SDL_image not found")
endif ()

find_package(SDL_mixer)
if (SDLMIXER_FOUND)
    target_link_libraries (beret ${SDLMIXER_LIBRARY})
else ()
    message(FATAL_ERROR "SDL_mixer not found")
endif ()

find_package(SDL_ttf)
if (SDLTTF_FOUND)
    target_link_libraries (beret ${SDLTTF_LIBRARY})
else ()
    message(FATAL_ERROR "SDL_ttf not found")
endif ()

target_link_libraries(beret m)

install(TARGETS beret DESTINATION lib/beret)
install(FILES AveriaSans-Regular.ttf DESTINATION lib/beret)
install(DIRECTORY images music rooms sfx  DESTINATION lib/beret)


