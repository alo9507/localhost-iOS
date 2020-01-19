<p align="center">
    <img src="https://github.com/alo9507/ContactiOS/blob/master/Contact/ItunesArtwork%402x.png" alt="localhost logo" width="250" height="250">
</p>

<h1 align="center">
    Welcome to the Localhost Codebase!
</h1>

We hope you enjoy your stay and find the architecture of the app to be a pleasure to work with.

Localhost iOS is built on a foundation of standard design patterns offering a common language and clear attack points for anyone integrating new features.

Below we've outlined the six main design patterns you'll need to know to be productive as you up-feature the Localhost app.

<h2 align="center">
    The 6 Central Design Patterns of localhost:
</h2>

- ### Dependency Container

Dependency Containers provide a one-stop-shop for managing object instantiation. This allows developers to easily intiialize the entire app in different environments, and removes the responsibility of instantiating ViewControllers from within other ViewControllers.

They also allow easy propogation of shared dependencies, like networkers.

The dependency container has two responsibilities:

1. It holds your shared dependencies, like networkers and other services
2. It has stateless factory methods for creating ViewControllers, ViewModels, and Coordinators which require those shared dependencies

[LocalhostAppDependencyContainer](https://github.com/alo9507/ContactiOS/blob/master/Contact/DependencyContainers/LocalhostAppDependencyContainer.swift)

- ### Repository Pattern

The Repository Patterns abstracts the implementation of your data access layer behind a generic, domain-driven interface which exposes simply-named CRUD methods.

This allows you to:

- Prevent coupling between the clientside application and any particular backend implementation
- Use MockRepositories for testing and prototyping in local environments

Localhost has 6 domain-driven repositories:

- UserSessionRepository: Synchronizes the cached, runtime and remote AuthSession and current User object
- UserRepository: Performs CRUD operations on User objects
- ChatRepository: Messaging primitives
- ChannelsRepository: Fetching chat channels
- SocialGraphRepository: Nodding at users and determining relationships
- UserReportingRepository: Reporting and blocking users

Localhost currently uses Firebase Backend-as-a-Service for data persistence and authentication. The iOS app itself however knows nothing about this implementation, and we'd like to keep it that way.

- ### MVVM

MVVM solves the MVC (Massive View Controller) problem which plagues many codebases. MVVM achieves this by removing all networking, processing, and logic out of the ViewController and into a different class, called a ViewModel.

In MVVM, the **only** responsibility left to a ViewController should be solely what its name implies: initializing the view and updating the view as data changes. This render and re-render resposnibility is facilitated by [Stateful Re-renders](#stateful-re-renders).

There are many means of communicating data changes from a ViewModel to its corresponding ViewController, including [RxSwift](https://github.com/ReactiveX/RxSwift), NotificationCenter, and delegation. Localhost uses **delegation**.

Resources:

Examples:

- ### Coordinator

The Coordinator Pattern extracts the responsibility of navigation from both ViewControllers and ViewModels into a separate class, called a Coordinator.

All references to _presenters_ (e.g. UIWindow, UINavigationController, UITabBarController, and UIViewController) are held in a Coordinator.

The coordinator is responsible for pushing new ViewControllers, presenting modals and alerts, and getting ViewControllers from the DependencyContainer.

Localhost uses multiple coordinators, each responsible for different flows of the app.

For example, the all important launch flow of the app is determined by:

1. First launch
2. Authentication state
3. If the app was opened from a push notification

The logic for the launch flow is coordinated by a special root coordinator called [ApplicationCoordinator](https://github.com/alo9507/ContactiOS/blob/master/Contact/Coordinators/ApplicationCoordinator/ApplicationCoordinator.swift)

Resources:
[Cocoacasts: Adopting the Coordinator Pattern](https://cocoacasts.com/mastering-navigation-with-coordinators-adopting-the-coordinator-pattern)

- ### Singleton

Singleton is used in:
Propogating changes to the current User object and AuthSession across the entire app:

Examples:

Managing the current [UserSession](https://github.com/alo9507/ContactiOS/blob/master/Contact/UserSession/UserSessionRepository/UserSession.swift):
[UserSessionStore](https://github.com/alo9507/ContactiOS/blob/master/Contact/UserSession/UserSessionStore.swift)

Managing Authentication state with the AuthManager:

[LHAuth](https://github.com/alo9507/ContactiOS/blob/master/Contact/Auth/LHAuth.swift)

A singleton LocalhostAppDependencyContainer is refernced on the AppDelegate:

[AppDelegate](https://github.com/alo9507/ContactiOS/blob/master/Contact/Configuration/AppDelegate.swift)

To maintain testability, you can find convenience testing initializers which allow you to inject UserSession and AuthSession, rather than pulling from the corresponding Singeltons:

[LHAuth](https://github.com/alo9507/ContactiOS/blob/master/Contact/Auth/LHAuth.swift)

- ### Stateful Re-renders

Stateful Re-renders are nothing new to web developers familiar with React.

The central equation of all UI:

> `UI = view(state)`

This really comes in handy as a standard practice when managing complex validation states, like onboarding text fields.

[OnboardingTextField](https://github.com/alo9507/ContactiOS/blob/master/Contact/Controller/Onboarding/Components/TextFields/OnboardingTextField.swift)
