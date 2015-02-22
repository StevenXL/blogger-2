# Blogger 2 - Notes #

This file will contain my notes as I work through [Jumpstart Lab's Blogger 2 Tutorial](http://tutorials.jumpstartlab.com/projects/blogger.html).

## Working with Databases ##

### What is a migration? ###
* Any modifications that can be done to a database (creating, updating, deleting) can be made through a migration.
* A migration is (usually, and if all goes well) platform agnostic. When we create a model, Rails automatically creates a database file in the 'db/migrate' folder. 
* If we look at the file above, Rails has called the 'create_table' method and passed to it ':arcticles' as a parameter. Within the code block 't' references the table that was just created.
* We call methods on 't' to manipulate the table. 

## Rails Console ##
* The rails console is a command line interface to our rails applications. It allows me to interact with the application without having to go through a web interface. 
* This allows us to make bulk upload and maintenance a less testing chore. 

## Looking at the Model ##
* Our models will be located at 'app/models'. 
* Rails uses a technique called reflection - it queries our database, looks at the columns in our table, and assumes that the names of those columns are also the attributes of our model. 
* Rails also automatically creates a column with the attribute of 'id', which is an integer, unique in the table, that helps identify each row. 

## Setting up the Router ##
* When a Rails application receives a request, the router determines what that request is trying to do, and what resources it is trying to interact with. 
* The router determines what the request wants to achieve by looking at the request's URL as well as the request's HTTP parameters, such as the method that is being utilized. 
* The router's configuration is located at 'config/router.rb'. 
* By adding 'resources :articles' in our 'router.rb' file, we are telling Rails that the resource named article will follow the RESTful model of web interaction. 
* Furthermore, the line above will also add a multitude of URL generators to our application. We can view the routes that are configured in our router by running 'rake routes'. 

### Understanding Routing ###
* When we run the 'rake routes' command, we see a table:
| Prefix | Verb | URI Pattern | Controller#Action |
---------------------------------------------------

* In our example, we get the following content for that table:
| Prefix   | Verb | URI Pattern          | Controller#Action |
--------------------------------------------------------------
| articles | GET  | /articles(.:format)  | articles#index    |

* The prefix of 'article' makes available two methods for us to use: 'articles_path' and 'articles_url'. 
* The '_path' version uses a relative path, while the '_url' version uses a full URL. The path version is preferred in all cases, except for redirects. 
* The verb is used by the router as another factor in determining what the request is actually asking for. For example, we can have a request that differs only on HTTP method, and route them differently. 
* The third column, URI pattern, is almost like a regular expression. The router will match the /articles(.:format) to '/articles', '/articles/', and '/articles.json'. The items in parenthesis are optional, but if we did not have it available, we would have to define a route for requests that came in with 'articles.json', 'articles.xml', etc. Note that articles.html is available by default. 
* The fourth column, finally, tells the router what controller and action pairing should be executed if a requests matches the route specifications. Remember that an action is equivalent to a method inside of the controller file.  

## Creating the Articles Controller ##
* Now that we have "told" the router where to send requests, we have to create the controller. We can do this by running 'rails generate controller articles'. 
* This action will create a controller file (in 'app/controllers'), a view (in 'app/views'), as well as helpers, test, and asset files in their respective directories. 

### Defining an Action ###
* Now that we have created the controller, we can create the first action - 'index'. 
* Because the expected action of 'index' is to list all of the articles, we will ask the controller to store an instance variable (@articles), and in that variable store whatever is returned from Article.all. 
* What we are doing here is using the controller to collect all the information that we will then pass to the view. The information needs to be stored in an instance variable (notice the '@' for the variable name) in order to make this information available to the view. 
* Now, if we visit 'localhost:3000/articles', we get an error, indicating that the template is missing.
* Using the fact that Rails is 'opinionated' software, it assumes that an action called 'index' in a controller called 'articles' **should** have a view in the 'app/view/articles' folder with the name 'index.erb'. 

### Creating the View ###
* So, we will create the file that Rails is looking for, 'app/views/articles/index.html.erb'. 
* Notice here that our file ends in 'html.erb'. The reason for the erb extension is that we want our file to be ran through the embedded ruby engine. Other files end in scss and coffee in order to run them through the SCSS and Coffee preprocessing engines, respectively. 
* Now that we have created this file, and Rails can find it, we do not get any errors, but we do get an empty page. This is because our 'index.html.erb' file should contain a mix of HTML and embedded Ruby in order to generate an HTML page from the data in our '@articles' variable!
* Now, we can add HTML to the file, along with Ruby in order to process the @articles object however we see fit. 

### ERB ###
* Embedded RuBy is a templating language that allows us to include Ruby in our HTML files. There are only a few things to remember about ERB:
* An ERB clause starts with '<%' or '<%=' and ends with '%>'. 
* If the clause starts with '<%', the results will **not** be inserted into the HTML file. 
* If the clause starts with '<%=', the results **will** be inserted into the HTML file. 

## Adding Links ##
* When adding links to my Rails application, I will want to use a "route helper" to specify where the link should point to.
* One of the biggest reasons to add a route helper is that, if the URL ever change, we do not have to go back through our application to change the links! Rails will automatically do that for us. 
* From our 'rakes routes' code, we got something similar to:
| Prefix  | Verb | URI Pattern              | Controller#Action |
-----------------------------------------------------------------
| article | GET  | /articles/:id(.:format)  | articles#show     |
* What this is telling us is that we can use article_path(id) to link to a URL that will show something about the article with the id specified. 
* Now, I can replace the code in our 'index.html.erb' view file. I will use '<%= link_to article.title, article_path(article) %>'. 
* What this is doing is using the link_to helper method. We are passing to it article.title as the text to display for the link, and then we are passing to it the URL that the text should link to.
* We can also pass in hashes to the link_to helper method: 'link_to text, URL, symbol: value'; when we do that, the symbol will be turned into an attribute and the value will be the value that that attribute is set to; in other words, we can add class, id, etc. through the template. 

### A Bit on Parameters ###
* Within the controller, we have access to a method named 'params'. Often, we will refer to it as the params hash, but technically params is a method that returns a hash. When we use a form, the params hash will contain the attributes as keys (strings or symbols) and the user's input as the values.

## Writing a Form ##
* Because we are using RESTful conventions, we can create a new form in which Rails will take care of many of the details. 
* We must create a form using the 'form_for' helper method. 
* In the create method, we use the params method to access the data submitted by the user through the form. 
* We can then redirect the user to the article using the redirect_to helper method, remembering to use the _url syntax and not the _path. 
* However, there is a correct way to access the data passed by the user.
* First, we should just pass in the entire params[:article] hash to Article.create. However, this would allow a malicious user to potential compromise the integrity of our app. 
* Rails gives us strong parameters to deal with the issue above. In a helper file ('app/helpers/articles_helper.rb') we define a new method that takes the params method and uses 'require' as well as 'permit' to require certain data in the submission, and to permit only certain data to be included in the database. The code would look like: 'params.require(:article).permit(:title, :body)
* We would also have to use 'include ArticlesHelper' in our controller file, and change our create action to use '@article = Article.create(article_params)'.

## Creating the Delete Action / View ##
* If we look in the 'rake routes' output, we can see that the delete action is mapped to the DELETE http verb, and the /article URL. We can fake HTTP verbs in Rails by passing a method: VERB as an option to our link_to helper: 'link_to "Delete This Article', article_path(@article), method: delete'.
* We can also add to our link_to another parameter: 'data: {confirm: "Message"}'; this will create a pop-up asking if the user really wants to delete the article. 

## Creating the Edit Action / View ##
* We create the edit action / view by adding the link to the show.html.erb file using link_to.
* Then, I have to create the edit action in the controller. 
* I must then add the edit view in 'app/views/article/'.
* After this, it is important to notice that the form that is going to appear in the edit.html.erb is the same as the form in new.html.erb. So, keeping with the principal of DRY, we are going to extract this code into a partial, and then reference this partial in both new.html.erb and edit.html.erb. 

### Creating a Partial ###
* Partials help us keep true to the principal of DRY by giving us a standard way of putting code that is going to be re-used in a single, authoritative place. 
* Partials live in the same place as our html - 'app/views/articles/', but their filenames have a **leading underscore**.
* To "tell" Rails to include a partial in our new / edit views, we would use code like this: '<%= render partial: 'form' %>'. Even though our file starts with a leading underscore, Rails is aware of that convention and will look for '_form.html.erb' in the appropriate directory.

### Flashes ###
* Flashes are used to send a message to the user. 
* flash.notice will fetch a value, while flash.notice = "My message" will store the string "My message" in the flash. 
* We can add a flash message to our actions with the line: 'flash.notice = "Message"'.
* Generally, the flash notice is put on the application's layout file so that we can easily insert flash notices on all our pages.
* Controllers will typically set flash messages for update, create, and destroy.
* You want to insert the flash notice BEFORE the redirect. This makes it so that only if the user goes through that action, the flash is properly set. 
