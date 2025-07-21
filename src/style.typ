// These are the Rirekisho styling functions.
//
// Generally, these are meant to be kind of used like Typst's built-in `show`
// functions. In essence, there are a bunch of `state` variables in this module
// that "style" (format) various parts of the resume. They can be overridden if
// desired and completely customized, as well as putting together a whole style
// to be shipped as one easily-applied piece.
// 
// See the default style as an example for writing custom styles.
//
// Here is a usage example:
// ```typst
// #let wacky-style = new-style-from-default((
//   // Set the name to always display this instead of the configured name
//   name: (value) => {"Whackamole"},
//   // Set the section text to be much larger, but keep the rest of the default
//   // style
//   section: (value) => {
//     [
//       #set text(size: 20pt)
//       #(default-style.section)(value)
//     ]
//   },
//   // Change elements to have a red outline and white infill
//   element: (value) => {
//     text(size: 12pt, stroke: 0.2mm + red, fill: white, value)
//   },
// ))
//
// #style.update(wacky-style)
// ```
// -----------------------------------------------------------------------------

// The default style. This should also be used as an example/template for
// writing custom styles.
//
// Styles consist of keys that define the type of resume part they style and a
// corresponding "show function", which should accept the value that needs to be
// styled and return styled content. The value given to styling functions can be
// assumed to already be some content or something that is directly-convertible
// to content such as via `[#value]`.
#let default-style = (
  // Styles the name of the resume-owner
  name: (value) => { text(weight: "bold", size: 12pt, value) },
  // Styles element titles within sections
  element: emph,
  // Styles section titles
  section: strong,
  // Styles timeframes
  timeframe: strong,
  // Styles locations
  location: text,
)

// Create a new style using the default style as a basis for missing style
// parameters.
//
// The only parameter `style` is a dictionary formatted just like a full style
// (see `default-style` for an example), except it may be a *partial* style. The
// returned value will be a full style dictionary.
#let new-style-from-default(style) = {
  let new-style = default-style

  for (key, value) in style {
    new-style.insert(key, value)
  }

  return new-style
}

// The global style state, which may be updated freely so long as the new value
// contains all style parameters. It is encouraged to use
// `new-style-from-default` for this purpose to fill any missing parameters
// automatically.
#let style = state("style-state", default-style)

// Reset the current style to the default style.
#let reset-style-to-default() = {
  style.update(default-style)
}

// The below functions are convenience for accessing the elements in the style
// since it can be cumbersome to do so manually.

#let name(value) = {
  return context (style.get().name)(value)
}

#let element(value) = {
  return context (style.get().element)(value)
}

#let section(value) = {
  return context (style.get().section)(value)
}

#let timeframe(value) = {
  return context (style.get().timeframe)(value)
}

#let location(value) = {
  return context (style.get().location)(value)
}
