// This is the common way Rirekisho handles timeframes throughout resumes.
//
// Here is a usage example:
// ```typst
// #show-timeframe(
//   (
//     start: datetime(year: 2042, month: 01, day: 01),
//     end: datetime(year: 2088, month: 08, day: 08),
//   ),
//   format: "[year]-[month]-[day]",
// )
// ```
// -----------------------------------------------------------------------------

// The default format to use when displaying `datetime` objects in the resume.
// This can be altered if the whole resume's date format style is desired to be
// different than the one provided here, but for one-shot differences most
// functions should allow a dedicated argument for changing the way `datetime`s
// are displayed for that one instance.
#let default-datetime-format = state(
  "default-datetime-format",
  "[month repr:short] [year]",
)

// Return content of the provided datetime in the provided format. If `format`
// is `none`, the default format will be retrieved from the state
// `default-datetime-format`.
//
// # Parameters
// - `datetime`: `datetime`
//     The object to format.
// - `format`: `str` | `none`
//     The format to use, which must be a valid argument to `datetime.display`.
#let show-datetime(datetime, format: none) = {
  if format != none {
    return datetime.display(format)
  }

  return context datetime.display(default-datetime-format.get())
}


// Convert a timeframe that has start and end fields into content.
//
// The timeframe will be formatted with an en-dash between the start and end. If
// either of them is `none`, the en-dash will still be inserted, and if both are
// `none` then `none` will be returned (note this is different from empty
// content).
//
// # Parameters
// - `start`: `str` | `content` | `datetime` | `none`
//     The start of the timeframe.
// - `end`: `str` | `content` | `datetime` | `none`
//     The end of the timeframe.
// - `format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year.
#let show-timeframe-with-endpoints(start, end, format: none) = {
  let result-content = none

  // Format `datetime` fields ahead of time so they can be treated like other
  // content down the line.
  if type(start) == datetime {
    start = show-datetime(start, format: format)
  }
  if type(end) == datetime {
    end = show-datetime(end, format: format)
  }

  result-content += start
  if start != none or end != none {
    result-content += [--]
  }
  result-content += end

  return result-content
}


// Convert a timeframe between two dates into content.
//
// # Parameters
// - `timeframe`:
//   `str` | `content` | `datetime` | `dictionary` | `array` | `none`
//     The timeframe to convert into content. See notes below for more how the
//     parameter can be formatted and how it's handled.
// - `format`: `str` | `none`
//     The format string passed to `datetime.display` if applicable. If `none`,
//     the format is taken from the state `default-datetime-format` (see also
//     `show-timeframe-with-endpoints` and `show-datetime` for more details.
//
// # Notes
// - The two forms a timeframe can take:
//     1. A non-container type, which may be any `str`, `content`, `datetime`,
//        or `none`. All of `str`, `content`, and `none` will not be modified,
//        so they will be converted as if `[#timeframe]` was used instead of
//        this function, or `none` in the case of `none`.
//        If the timeframe is a `datetime`, it will be converted using the
//        `display` method of `datetime` objects and the provided format.
//     2. A container type, which is either a dictionary with `"start"` and
//        `"end"` keys, or an array of two elements where the order of elements
//        is `("<start>", "<end>")`. The elements must be any valid
//        non-container type for the `timeframe` parameter as described above,
//        where each element will be handled as described, with the addition
//        that an en-dash will be inserted in the middle. The en-dash will
//        always be inserted *unless* both endpoints are `none`, in which case
//        just `none` is returned.
#let show-timeframe(timeframe: none, format: none) = {
  let result-content = none

  if type(timeframe) in (dictionary, array) {
    let (start, end) = timeframe
    result-content += show-timeframe-with-endpoints(start, end, format: format)
  } else if type(timeframe) == datetime {
    result-content += show-datetime(timeframe, format: format)
  } else {
    result-content += timeframe
  }

  return result-content
}
