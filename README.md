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
<p align="center">   Application Design </p>

<p align="center">
    <img width="425" alt="Снимок экрана 2021-07-26 в 15 49 01" src="https://user-images.githubusercontent.com/87068027/126991382-9eb9e8d7-1bdd-4886-82a6-3f8a070fdb8a.png">
<img width="425" alt="Снимок экрана 2021-07-26 в 15 49 21" src="https://user-images.githubusercontent.com/87068027/126991405-b7263e8d-5341-4b07-b8ad-6a894c0e85a3.png">
<img width="425" alt="Снимок экрана 2021-07-26 в 15 49 31" src="https://user-images.githubusercontent.com/87068027/126991417-b90041ac-508d-4b3b-92d4-cd6334c90d2b.png">

</p>
