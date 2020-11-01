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
  modules     = { "markdown", "gallery", "download", "footer" },

  -- define default colors
  colors      = {
    ["accent"]      = "#3a5",
    ["border"]      = "#eaeaea",
    ["bg-page"]     = "#fafafa",
    ["bg-content"]  = "#fafafa",
    ["bg-sidebar"]  = "#fff",
    ["fg-page"]     = "#222",
    ["fg-sidebar"]  = "#222",
    ["customcss"]   = "",
  },
}

