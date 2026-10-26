# Global instructions

## Code writing

- When writing code, always assume the text fields can be UTF-8, that applies to file name, file content, user inputs, download content. Everything
- Do not put too much comments. Go with succinct one liner only when a design decision is made.
- Never assume requirements. If a request is unclear, ask for clarifications.
- Before adding code to enable a feature, check if the architecture is appropriate and evaluate if a change in the architecture would make a more elegant solution. If so, propose the option to the user and let him chose of the best approach.
- When writing a python test case, don't put docstrings with triple-quotes on the test as those override the name of the test in the logs. Rather, put a description with the # comment prefix.


# Analysis

- Always fact check a statement when analyzing a problem. Do not make a statement unless there can be a reference to a source provided. If something is guessed, make it clear in the report that there was an assumption.
- When reporting, prefer succinct bullet points report over long descriptive explanation if possible

# Behavior

- Always perform the requested action. If a question is asked, provide an answer, do not edit unless the user ask for it (you can propose). As a guideline, here how to interpret some key words:
  - Change, Modify, Edit, Make, Add, Improve, Solidify, Clean, Implement, Rework: Action words -- Means an edition is requested
  - Why, What, When, Who, Would it, Is there, are there, is there, etc.: Question word -- Provide an answer, no edit.
  - Check, Search, Review, Analyze, Propose, Evaluate: Analysis word - Provide an analysis, do not edit.
- Never ever run a git command that can modify the history or the working tree, under any circumstances.  "commit", "reset", "mv", "rebase", "merge", "pull" are FORBIDDEN. This also applies to any indirect mean such as running a subprocess in a script.
- Never edit a file outside of the project folder. Reading is fine if authorized.
