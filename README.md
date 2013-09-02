# Shinda Sekai Sensen

Shinda Sekai Sensen (literally. Afterlife War Front) is a project designed to remove the chrome from Minecraft player administration.

## The Problem

There are lots of servers, and lots of rules for each server. Players are aware rules exist, but often don't read them in depth or remember them verbatim in all cases. In these scnerios, admins are usually faced with the following choices:

* Tell the user nicely while they're playing the game that they did something wrong.
* Ban the player for a temporary amount of time because the offense wasn't "severe."
* Ban the player forever because they broke a *really bad* rule.

Shinda Sekai Sensen is a *battle* against broken administration. While the first idea works, it may not be suitable for complicated cases or when a player isn't online for a long time. The second choice is somewhat better than the first, but its problems are twofold: Players may not join to notice the ban for a long amount of time (and thus it may expire before they join), or they may never come back as a result of being temporarily banned for too long. Lastly, banning a player forever loses the chance for that player to be active in the community.

Shinda Sekai Sensen adopts the principles of assuming good faith. Every player is considered honest, until they show that they have malicious intent to harm others. While this may very well allow bad players to be on a server longer, modern [rollback technology](http://discover-prism.com/) makes dealing with these players a simple affair.

Only after a player has been shown or exhibits actions that are offensive can the player be flagged as such and removed from the community.

Because all actions take place on the website, admins are encouraged to use long, thought out warning and ban reasons to convey better messages than a simple ban reason provides. In short, it allows for better reasons easier and better players.

### Pitfalls

* Admins may not care enough to use it.
* Admins may ignore warnings and just flag bad players.
* Admins may abuse players more ingame.
* Admins may leave the community after being introduced to this.

## This thing

This was my first Ruby app, and first Sinatra application. It contains some files needed to assemble the database, build, and execute the app. However, it is not in a stable form. It **should not be used** on a server that isn't willing to face bugs, such as:

* Data loss
* Inability to keep players out
* Unsufficient admin training

### Pitfalls

Currently, there are several design problems that will be addressed before a fully public release is announced and supported. They are:

* No usage of a modular database system such as ActiveRecord or Sequel. This uses raw database connections.
* Little permission/authentication support.
* Inconsistent database names.
* Inconsistent data access.
  * Inconsistent model use and access.
* Some database fields are setup to support Steam.
* Some code is ShankShock specific.
* Some code is Heroku specific.
* Only supports Google+ authentication right now.
  * Planning on supporting Steam authentication as an alternative.
* Very little is documented. Existing documentation is using TomDoc.

This is a proof of concept for the idea of Shinda Sekai Sensen and an attempt to solve the problems above. It is being used at [ShankShock](http://shankshock.com/) on a full time basis in order to test, but will be available for the community in a supported form soon.

Even if this doesn't work in practice, I hope it serves as an example of principles that can be used in further development of communities.
