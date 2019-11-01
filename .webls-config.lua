return {
  -- generic website options
  title       = "ericmauser",
  description = "just some random notes",
  website     = "https://www.ericmauser.de",
  cname       = "ericmauser.de",

  -- add "index.html" to the end of each link
  pagesuffix  = nil,

  -- folder that shall be scanned for content
  scanpath    = "content",

  -- the output directory that is later used as webroot
  www         = "www",

  -- modules that should be used for parsing
  modules     = { "markdown", "git", "gallery", "download", "footer" },

  -- define default colors
  colors      = {
    ["accent"]      = "#198944",
    ["border"]      = "#eee",
    ["bg-page"]     = "#fff",
    ["bg-content"]  = "#fff",
    ["bg-sidebar"]  = "#fff",
    ["fg-page"]     = "#222",
    ["fg-sidebar"]  = "#000",
  },
}

