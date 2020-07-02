# Dark Hand

Dark Hand is a small command line tool written in Elixir. Its main purpose is downloading files. It can follow redirects (HTTP codes 301 and 302) and it downloads files asynchronously. Its core downloading performance is comparable to the UNIX/Linux wget utility.

Detailed estimation/development time statistics issue: [click here](https://github.com/Oleksii-Kshenskyi/dark_hand/issues/1)

Dark Hand's Run One Kanban board: [click here](https://github.com/Oleksii-Kshenskyi/dark_hand/projects/1)

# How to build it?

Dark Hand has been tested on Manjaro and Windows. It should be functional on any platform where there Elixir >= 1.10.0 available.

## On Manjaro/Arch

- `sudo pacman -S git elixir make`
- `git clone https://github.com/Oleksii-Kshenskyi/dark_hand.git`
- `make`

## On Windows
- You could use the [official website](https://elixir-lang.org/install.html#windows) to install Elixir.
- You could also use a package manager like [Chocolatey](https://chocolatey.org/install) or [Scoop](https://scoop.sh/).

My personal setup would be as follows:
- Install scoop: 
  - Open PowerShell: press `windows` key => type "PowerShell" => right click => "Run as Administrator"
  - Run this command to install scoop: `Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')`
  - If you got an error on the installation step above, run `Set-ExecutionPolicy RemoteSigned -scope CurrentUser` in PowerShell and re-run the installation.
- Re-launch PowerShell.
- `scoop install git` <= installs Git for Windows with Git Bash.
- Open Git Bash (e.g. press `windows` => type 'Git Bash' => Enter).
- `scoop install elixir`
- `git clone https://github.com/Oleksii-Kshenskyi/dark_hand.git`
- `make`

## After the build is successful

After `make` is invoked, mix (Elixir's package manager) should fetch all the dependencies and build the application. Note that Elixir/Mix may ask you to install additional Erlang/BEAM internal packages like Hex and Rebar3. You have to agree to this or otherwise it won't work.

Once this initial build is done, you could use `make b` for an incremental build (to not re-fetch dependencies each time you build) and `make uf` for fast unit testing.

## How does it work?

At the moment, the only thing Dark Hand can do is download files. There was a plan originally to implement downloading files from and uploading them to DropBox, but unfortunately there was no opportunity to dedicate enough time in May 2020 to implement that functionality.

To download files, after `make` finishes successfully and an executable called `dark_hand` is generated, run the following in the command line:
`./dark_hand -d <URL>` <= Linux
`dark_hand -d <URL>` <= Windows

Note that `<URL>` here means a full standard URL like `https://http.cat/404.jpg` or `https://www.printme1.com/preview/223ab3477?goto=download`. Dark Hand will follow redirects like in the latter example and download the target .pdf file.

Also note that Dark Hand rejects URLs without explicitly specifying protocol (`http.cat/404.jpg`) and top-level domain URLs(`http://google.com/`). This is done on purpose to ensure safe behavior of the application.

# Useful info

This is a project that had been made from the ground up on the idea of doing it within a single months, not knowing anything about either Elixir or functional programming, or even about networking development. It was eventually made within the period of 05/01/2020 - 05/15/2020, just 2 weeks.

For precise statistics on estimations and time spent on this project, please refer to issue [#1](https://github.com/Oleksii-Kshenskyi/dark_hand/issues/1) of this project.

For this project's kanban board, see [here](https://github.com/Oleksii-Kshenskyi/dark_hand/projects/1).
