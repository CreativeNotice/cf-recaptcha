CF-reCAPTCHA
============

> "A CAPTCHA is a program that can tell whether its user is a human or a computer. You've probably seen them — colorful images with distorted text at the bottom of Web registration forms. CAPTCHAs are used by many websites to prevent abuse from "bots," or automated programs usually written to generate spam. No computer program can read distorted text as well as humans can, so bots cannot navigate sites protected by CAPTCHAs." - Google

CF-reCAPTCHA is a simple Coldfusion component, written in script, which allows you to easily utilize Google's reCAPTCHA service. You'll need to be running at least CF 9.

Contribute
--------

I'd love to hear your ideas to make this CFC better. Please fork and send me a pull request with your ideas. Or, at the very least post any [issue] [2] you come across here on GitHub.


Setup
-------------------

If you're using the CFC with one pair of public / private keys from reCAPTCHA then feel free to edit the ```init()``` method's argument defaults. Just add your public and private keys and you won't have to ever type them out again when using the other methods of the CFC.

If, however, you may need to use multiple pairs of keys, you can set them during use. To do so you'll use the ```init()``` method. *See that method's documentation below.*

To use this component, add it to your CF environment like any other component. Then create the CFC object using:
```re = new recaptcha();``` or ```re = CreateObject( 'component', 'recaptcha' );```

Use
-
There are three methods available to you: ```init()```, ```check()```, ```display()```.

---

init()
----
```init()``` is where we set our defaults, or override them as well. To set defaults you'll want to edit the CFC. Simply fill in the method's argument defaults. Available arguments are:

* ```pub_key```   {string}  - This should be your public key from the site defined in your reCAPTCHA account.

* ```priv_key```  {string}  - This is just like the public key, but is private.

* ```theme```     {string}  - Default is 'red' but you can set 'red' | 'white' | 'blackglass' | 'clean' | 'custom'.

* ```lang```      {string}  - The language to use. To see available options check out the [doc from Google] [1].

* ```tab_index``` {numeric} - Any numeric tab index. Default is -1 which means no index.

* ```https```     {boolean} - Default is **AUTO**, which will cause the CFC to decide if HTTPS is needed based on 
                              what your site is serving content as. If you set **TRUE** you'll force HTTPS for the API
                              requests to Google's servers. Conversly, **FALSE** will always force plain HTTP.


> *NOTE: You only need to set ```pub_key``` and ```priv_key```. The other arguments already have defaults set.*

To use init be sure you already have an instance of the CFC created, *as shown in Setup above*, and then pass your arguments through like so:

```re.init( pub_key='mypubkeyhere', priv_key='myprivkeyhere', theme='blackglass' );```

When you later use the ```check()``` and ```display()``` methods they will use the defaults you set here.

---

display()
----------
```display()``` does exactly what you expect it should, display the reCAPTCHA UI. You don't need to pass it any arguments at all but if you wish to override the defaults set in the CFC or by calling ```init()``` you may pass in:

* ```pub_key```   {string}  - This should be your public key from the site defined in your reCAPTCHA account.

* ```priv_key```  {string}  - This is just like the public key, but is private.

* ```theme```     {string}  - Default is 'red' but you can set 'red' | 'white' | 'blackglass' | 'clean' | 'custom'.

* ```lang```      {string}  - The language to use. To see available options check out the [doc from Google] [1].

* ```tab_index``` {numeric} - Any numeric tab index. Default is -1 which means no index.


---

check()
----------
```check()``` is the real work horse. It does the http request to the Google servers to check your user's input. No arguments are required here since we pass the user's IP, the challenge and their response automaticly. 

> *NOTE:  If you passed a different ```pub_key``` and ```priv_key``` when you used ```display()``` besure you pass the same keys to ```check()```.* 


[1]: https://developers.google.com/recaptcha/docs/customization#i18n
[2]: https://github.com/CreativeNotice/cf-recaptcha/issues