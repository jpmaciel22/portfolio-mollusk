#lang mollusk
:- header -:
:@ for post posts @:
  <main>
    <article class="post">
    <h4>:~ (hash-ref post "data")~:</h4>
    <p> :~ (hash-ref post "content") ~:</p>
    <img src=":~ (hash-ref post "image") ~:"/>
    </article>
  </main>
  <hr/>
:@ end @:
:- footer -:
