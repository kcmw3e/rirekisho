// This is the common way Rirekisho handles timeframes throughout resumes.
//
// Here is a usage example:
// ```typst
// #show-timeframe(
//   start: datetime(year: 2042, month: 01, day: 01),
//   end: datetime(year: 2088, month: 08, day: 08),
//   date-format = "[year]-[month]-[day]",
// )
// ```
// -------------------------------------------------------------------------- //

// Convert a timeframe between two dates into content.
//
// The timeframe will be formatted as follows:
//   [`start`]{--}[`end`]
// The en-dash will always be present *unless* both `start` and `end` are
// `none`.
//
// # Parameters
// - `start`: `str` | `content` | `datetime` | `none`
//     The start of the timeframe.
// - `end`: `str` | `content` | `datetime` | `none`
//     The end of the timeframe.
// - `date-format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year. This only takes effect
//     when a work experience `start` or `end` field is a `datetime` and gets
//     ignored otherwise.
//
// # Notes
// - Any field passed as type `content` or `str` will not be modified.
#let show-timeframe(start: none, end: none, date-format: none) = {
  if date-format == none {
    date-format = "[month repr:short] [year]"
  }

  let result-content = none

  // Format `datetime` fields ahead of time so they can be treated like other
  // content down the line.
  if type(start) == datetime {
    start = start.display(date-format)
  }
  if type(end) == datetime {
    end = end.display(date-format)
  }

  result-content += start
  if start != none or end != none {
    result-content += [--]
  }
  result-content += end

  return result-content
}
