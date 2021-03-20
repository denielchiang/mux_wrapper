# MuxWrapper

Mux API wrapper, trun API response JSONB to embedded schema.

## Todo

### VIDEO API
#### Assets
- [x] Create an asset
- [x] Retrieve an asset
- [x] Delete an asset
- [x] List assets
- [x] Retrieve asset input info
- [x] Update mp4 support
- [x] Update master access
- [x] Create a subtitle text track
- [x] Delete a subtitle text track

#### Playback IDs
- [ ] Create a playback ID
- [ ] Retrieve a playback ID
- [ ] Delete a playback ID
- [ ] Retrieve an Asset or Live Stream ID

#### Live Streams
- [x] Create a live stream
- [x] Delete a live stream
- [x] List live streams
- [x] Signal a live stream is finished
- [x] Disable a live stream
- [x] Enable a live stream
- [x] Create a live stream playback ID
- [x] Delete a live stream playback ID
- [x] Retrieve a live stream
- [x] Reset a live stream’s stream key

#### Simulcast Targets
- [x] Create a simulcast target
- [x] Retrieve a simulcast target
- [x] Delete a simulcast target

### STREAM URL API
#### Playback
- [ ] Play an asset

### IMAGE URL API
#### Thumbnails
- [ ] Get Thumbnail

#### Animated GIFs
- [ ] Get GIF

#### Storyboards
- [ ] Get Image
- [ ] Get VTT
- [ ] Get JSON

## Installation


If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mux_wrapper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mux_wrapper, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mux_wrapper](https://hexdocs.pm/mux_wrapper).

