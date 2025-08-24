#import "@local/resumania:1.0.0": *

#let author = "John Doe"

#let contacts = Contact-section(
  phone: Phone("+0 (123) 555-0123"),
  email: Email("john.doe@example.com"),
  linkedin: Link("LinkedIn", "example", "https://linkedin.com"),
  github: Link("GitHub", "example", "https://github.com")
)

#let education = Education-section(
  masters: Education(
    institution: "Some School",
    location: "Anywhere",
    kind: "M.S.",
    study: "Mechanical Engineering",
    timeframe: datetime(year: 2042, month: 4, day: 2),
    score: 3.44,
    scale: 4.0,
  ),
  undergrad: Education(
    institution: "Another School",
    location: "The other place",
    kind: "B.S.",
    study: "Physics",
    timeframe: 2044,
    score: 3.11,
    scale: 4.0,
  ),
)

#let work = Work-section(
  Work(
    company: "Some Company",
    location: "Anywhere",
    position: "Mechanical Designer",
    timeframe: (
      start: datetime(year: 2045, month: 08, day: 08),
      end: "Present",
    )
  )[
    - Designed parts to go on aircraft for the future.
    - Ran simulations to ensure parts would meet factors of safety so the final
        product could pass standards.
    - Worked with customers to generate specifications and requirements for the
        aircraft and its features.
  ],
  Work(
    company: "A Different Company",
    location: "Somewhere Else",
    position: "Mechanical Engineer Intern",
    timeframe: (
      start: datetime(year: 2040, month: 06, day: 01),
      end: datetime(year: 2040, month: 08, day: 20),
    )
  )[
    - Performed calculations and simulations for structural elements to a space
        elevator that could carry 2 tons of payload.
    - Provided feedback to other engineers regarding the physics behind a space
        elevator and material requirements so it doesn't berak.
  ],
)

#let projects = Project-section(
  Project(title: "Automatic Spellmaker", timeframe: "The Year of Spirits")[
    In this project, I created an automatic spell making apparatus, inspired by
      the spirits that arose in The Year of Spirits.
    - The apparatus could make 50 spells every day.
    - It consumed 5 Tubes of mana for every spell created.
  ],
  Project(
    title: "Self-writing Paper",
    timeframe: datetime(year: 0038, month: 5, day: 1),
  )[
    - Through experimental efforts, created paper that writes on itself.
    - The paper can write as fast as any being, and without tiring.
    - The paper only requires 1 Tube of mana a day.
  ],
)

#let skills = Skills-section(
  Skillset(
    "Simulation",
    "Simulation Software 1",
    "Simulation Design",
    "FEA Software",
  ),
  Skillset("Software", "Office Suite", "CAD Software"),
)

#show: resume.with(author, contacts, education, work, projects, skills)
