# Flutter DropdownTextfield

A DropdownTextfield is a material design button. The DropDownButton is a widget that we can use to select one unique value or multivalue from a set of values.

##Key Features
* (asterisk) Sync and/or Async items (online, offline, DB, ...)
Searchable dropdown
Three dropdown mode: Menu/ BottomSheet/ Dialog
Single & multi selection
Material dropdown
Easy customizable UI
Handle Light and Dark theme
Easy implementation into statelessWidget
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)


## Section 1

This section treats about how to properly configure custom Git commands such as {+ git c +} wich corresponds to {+!git add --all && git commit -m+}. It saves some time commiting and pushing new changes.

## Section 2

This section brings some light on the clean architeture way of programming. It creates layers, where you can separate your code in a way where any future changes won't be hard to be implemented. Also, this layers makes sense for the codes it contains.

This section separates the code on 2 layers: **Domain** and **Data**. Domain creates an abstraction for our Auth/Login method, and its return, an Account. Account is an entity with a token (returned from user login). Data on the other hand implements the business logic to treat the HttpClient answer so a domain object can "understand" it, and also to make the request properly so the HttpClient service can ask/request it on the right way. It stands in the middle, like a "translator". The HttpClient service will lay on a third class, the **Infra**, that will be explained later.

Further more, the section starts the TDD, creating tests for the RemoteAuthentication method. TDD is good because we create a test for a code that doesn't exist yet, run this test (it should fail), correct it, refactor and then end up with a functional and tested code, free of redundancy. After this, we create a method to mock the httpClient requests and its data.

Finishing this section should provide you with a clean architeture implementation for the Login/Authentication method, with a high level of modularization of the components, that should allow you to change things without too much headache, such as the library for httpRequest or the fields used on the login method.

## Section 3

This section creates an adapter that will deal with the HTTP request itself. It uses a Client class and a Response class from the HTTP package. The first one will make the request and the second one will handle the response. If the response throws an error, we count with the HttpError class from the **Data** layer to deal with it. If the request/response succeeds, no error is thrown.

## Section 4

This section deals with the User Interface (UI) implementation. Basically, we create the components that will compose the Login Page. We create the Login Header, the Form fields for email and password, the Login button and the Sign Up button. All the components are created by testing, so all the required fields and form login enable/disabled button are tested.


## Section 5

This section creates tha **Presentation** layer wich will deal with the Login page listeners. Basically, it will notify the **Validation** layer every time a change or an action occurs on the Login Page and call validation methods upon them.

## Section 6

This section implements **Validation** layer and validation methods for inputs such as email, password and others (field validation protocol).

## Section 7

This section brings all the components we created together to create the Login Page. Also, introduces the factories concept to "produce" the page only when it is needed. 

