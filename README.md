# GitHubRepList-Core-data
Recieving open repositories from api.github, and use that info to show them in table view in list type.

- So, for this project I used:
- network requests
- JSON Decoder
- Custom data Model
- WKWebView for detail VC.
- asynchronous code execution
- data processing with help of closures
- and in the end, was added a core data search history saving, (project works good), BUT
    func fetchSearchHistoryAndRepositories or func updateSearchResults causes a repeating BUG in extenGitHubVC.swift between lines 142 and 192.
    this problem is solved by deleting a previous array data every time, however, this is not a good solution at all. I don't know how to solve it, but i should
    notify you that such ploblem exists.

      Good luck, and I wish you successful programming =)
