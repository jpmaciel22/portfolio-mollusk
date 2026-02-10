#lang mollusk
:- header -:

:@ for post posts @:

<main>
    <article>
    <h4>:~ (hash-ref post "title") ~:</h4>
    <p>:~ (hash-ref post "content") ~:</p>
    <img src=":~ (hash-ref post "image") ~:"/>
    </article>
</main>
<hr/>

:@ end @:

:- footer -: