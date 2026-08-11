---
layout: "@/layouts/Layout.astro"
title: "STUDIOS"
---

<style>
/* Reset and Header Hiding */
header, .header, .blog-title, .title { display: none !important; }
body { padding-top: 0 !important; color: #ffffff !important; }
#main-content { padding-top: 0; }
h3.post-title.entry-title { display: none !important; }
.post-body, .post-header, .header-inner, .content-inner, .main-inner { padding-top: 0 !important; }
.post-body, .post-header, .header-outer { margin-top: 0 !important; }
.post-body img { box-shadow: none; border: 0px; }

/* Link Styling */
a:link, a:visited { color: #60a5fa; text-decoration: none; }
a:hover { color: #c084fc; text-decoration: underline; }

/* The Master Container - Keeps everything centered like Blogger */
.page-container {
    max-width: 800px;
    margin: 0 auto; /* Centers the container */
    padding: 0 20px 40px 20px;
}

/* Banner and Typography */
#banner { position: relative; width: 100%; text-align: center; }
.section-title { color: #999999; font-size: 3em; font-weight: bold; margin: 3rem 0 0 0; line-height: 1.1; }
.section-subtitle { color: #999999; font-size: x-large; font-weight: bold; margin-top: 0.5rem; margin-bottom: 2rem; }
.illustration-credit { color: #999999; font-size: small; margin-top: -1.5rem; margin-bottom: 2rem; }

/* Layout Containers */
.flex-start { display: flex; justify-content: center; align-items: flex-end; gap: 2rem; flex-wrap: wrap; margin: 2rem 0; }
.single-image-center { text-align: center; margin: 3rem 0; }

/* Strict 2-Column Grid */
.grid-2-col { 
    display: grid; 
    grid-template-columns: 1fr 1fr; 
    gap: 2rem; 
    justify-items: center; /* This centers the images inside their columns */
    align-items: end; 
    margin: 2rem 0; 
}

/* On mobile screens, stack the images */
@media (max-width: 600px) {
    .grid-2-col { grid-template-columns: 1fr; justify-items: center; }
    .flex-start { justify-content: center; }
}

</style>

<h1 class="text-center text-[36px] font-bold leading-[60px] text-[#94a3b8]">Åpecranꓘ: The Tenebric Symplecticum</h1>
<!-- Link Navigation Row -->
<div style="display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 60px; margin-bottom: 2rem;">
  
  <a href="/" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [HOME]
  </a>

  <a href="/collaborators" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [COLLABORATORS]
  </a>

  <a href="/studios" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [STUDIOS]
  </a>

  <a href="/labs" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [LABS]
  </a>

  <a href="/code" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [CODE]
  </a>

</div>

<!-- The Master Container Starts Here -->
<div class="page-container" style="--text-nudge: 40px; background-color: #f1f5f9;">

<div style="text-align: center; margin-bottom: 2rem;">
  <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgf7ty0oBYQjTynnpOcJiFgp1_NW0fJdKLyoMxhKe1RCqhy3zBl-oPDBOxi7Jvz9cewShy3OOBPsPYNlCfC_yTTfHUDgomWoidm1UCAywd-9e1fSPsea58Lgl2ImTEhE0HYokoPobXLXKGxjBZLa1JLyupA83GKRjwRyH2Y7MrXGFDlwZGrxnJoAZ14pHs/s1600/-pecran-Studios-10-1-2025.png" alt="Studios Banner" style="width: 100%; height: auto; transform: scale(0.975);" />
</div>

<br><br><br>

  <!-- Rampart Section -->
  <div style="text-align: left; margin-left: var(--text-nudge);">
    <div class="section-title">Rampart Chess:</div>
    <div class="section-subtitle">(A Game of Perfect Information)</div>
  </div>

  <div class="flex-start" style="gap: 8rem;">
    <a href="/rampart_rulebook" target="_blank">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg8ocw1o4FVWMGND8IDm-5Az3AIUOtYpA1kT3gv9DTIbBdwGq3Da-kXCE4tmNSP5b80F6zmRlNtpePnEqkCRAshOyDbFxbgrqHSfgYM4HVeF5UZagTIsJhkRvAhyphenhyphenENz7eIMmrSgIn8GbLFzhxZx-g3kgYVgFmaWG9bQBW9CxMcJgBVp69AUR-mPvltmTSU/w249-h359/rampart_offical_rules.png" alt="Rampart Rules" height="359" width="249" />
    </a>
    <a href="https://github.com/jerodmichel/rampart" target="_blank">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjTqDOrpDzvbbezGDTLco8d_3SgA6K20tzDj4OahbnJzoNlOvGNLEw1w7hjywdtwO9_-gkjWQ0Vi0yNM-FarBZ21rrEt6jWoe4eI1ryzmaEpnLmPp5P4ZIYooBSc_iXDVuD7kHcOlO9ULMkTygw2bJToL-b-TuJQUyWe3F9xLvx1D3CkojAXMVnCQs-B-g/w240-h351/rampart_release.png" alt="Rampart Release" height="351" width="240" />
    </a>
  </div><br>

  <div class="flex-start" style="margin-left: 40px;">
    <iframe width="100%" style="max-width: 526px;" height="371" src="https://www.youtube.com/embed/TWDltWxu2pY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </div>
<br><br><br>
  <!-- Kristopher Lawrence Section -->
  <div style="text-align: left; margin-left: var(--text-nudge);">
    <div class="section-title">Works of Kristopher<br />Lawrence:</div>
    <div class="section-subtitle">(Published on <a href="http://theweirdcrap.com">theweirdcrap.com</a>)</div>
    <div class="illustration-credit">Illustrations by Billy Hill</div>
  </div>

  <div class="grid-2-col">
    <a href="https://theweirdcrap.com/alarmingly-strange-stories/witches-of-rascar-pablo-part-i/" style="transform: translateY(-50px);">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEijGhWisLDncBYVJ6U5EzyPTHXqChA9F4Zfu0t6eypqX0KgEDLXswEXQutQUdNxm42jJcitKlcw18hFklIrPTGec-y6KPgSt7L2soZLxn4rWDf5xXnCRXw-nAOe6yj02A43fjidOsMCNzgNXQV3lsizCqhpAW0FJGkElYcaswfiPa6DENo1WYptbLzxo8g/w253-h243/heart_boy_3_TT.jpg" alt="Heart Boy" width="253" height="243" />
    </a>
    <a href="https://theweirdcrap.com/alarmingly-strange-stories/witches-of-rascar-pablo-part-ii/">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgeyTmxrB__mMoGAdgr7dtUITk5P1QCyt9DWrPtPVQyLnKAoz4NCvFwUp9wKU02XxBqXsgfT3A7AUFVd9mCdqcKAdHrxqpt2LEe2Eh7XFuAWIZAbmyp7paAZre3DmgUjpTraIDEynOwoADgEugUnmzSCzmF8sJFQQaJldNYWZzJGAtDrR9fxf4EOPSpmQw/s320/southern_oracle6_TT.jpg" alt="Southern Oracle" width="279" height="320" />
    </a>
    <a href="https://theweirdcrap.com/alarmingly-strange-stories/witches-of-rascar-pablo-part-i/" style="transform: translateY(-10px);">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg5v_6X_6UiWnRvSg4R6S8XHasQzxpGOA7cLZbQF8xud6hSek_1aCmv1f_ASWfCH6ANvh__fVG0wCC_w2hv0aeqjqpcCWyt4Tncf41Afxiyw1ivSajkhYOMS4vA-UKALtwtdUN4D_x_Ep5nRdB_Olyv_YZPhT5D3AivWXWWIzF6LbTibzqrPHwpTRaVcFs/s320/quetzl_TT.jpg" alt="Quetzl" width="240" height="320" />
    </a>
    <a href="https://www.amazon.com/Witches-Rascar-Pablo-Kristopher-Lawrence-ebook/dp/B0CWTJPVSL/">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjMspofnQnyJESxM9gMqH32lhmsIZsKBuZYTRk0Cfd2uMwt7uylgDa9B0Jv5980cVbcKDdf5BEWiZxwkXOhP7YYVjkBSLJjj-Dl8YloX41KK1E4mBxPJ_MSj3VLfqGaNgiNDfQm0JuBQ-6gUVM9ILRG0nFwhVNNMYepGL39iU2REzdO6XAWbTBNfwFjjfo/s320/wasp_silo.png" alt="Wasp Silo" width="320" height="262" />
    </a>
  </div>
<br><br><br>
  <!-- Notes from China Section -->
  <div style="text-align: left; margin-left: var(--text-nudge);">
    <div class="section-title">Notes from China:</div>
    <div class="section-subtitle">(Published by Hyperion Academic & Tech, LLC)</div>
    <div class="illustration-credit">Illustrations by Billy Hill</div>
  </div>

  <div class="grid-2-col" style="align-items: center;">
      <!-- LEFT COLUMN: The two stacked images -->
      <div style="display: flex; flex-direction: column; gap: 2rem;">
        <a href="/days-in-china">
          <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgL-x4Jnt3P2B4Gu8pEYGydVjsclPgX5yg1GwSy4MkLYwh3fdKvohaH5HqIFa9g8JjKRazs5LYtQXRMIhPUGRrZHNacHZXYgjKIOdQzh8VNx9G1g3_JVyAq46VG8rxq0Nxpti5arEm4qzrst0MfDy-Bbbmepr79LlwPMe5IvKzR2wNL0zSmueR4xZiOnwo/w200-h199/Lucid_Origin_Chinese_warrior_with_determined_facial_features_d_2_C.png" alt="Chinese Warrior C" width="200" height="199" />
        </a>
        <a href="https://www.amazon.com/dp/B0D2YW531Y">
          <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgJ1LrR_c4zaSlWqHvfnl0MG2s3Mn2gWBzNcSbUTaDyA6_7DsRSAQZG-tRIcYauSG7NFVrFuBQ9nIq9pby7QU5XzSv-7aZpGx6mzxRknZLx0Fcjr6GchzJ3mg2mWdGZa9klQdXy_UR46WMOnV9sgHLC8-VdgCLVn0mnxoOU5lWv6NbhOWAm_7qtpFBQQYo/w200-h188/Lucid_Origin_Chinese_warrior_with_determined_facial_features_d_2_A.png" alt="Chinese Warrior A" width="200" height="188" />
        </a>
      </div>
      <!-- RIGHT COLUMN: The tall diagram -->
      <a href="https://apecrank.blogspot.com/2011/03/notes-from-china.html" style="transform: translateX(-50px);">
        <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi3sN_MyHmrKdOgSQ4ZFjKSDN3Z_3hdym7CPiI9ocwlQVLiDZS8J54nZal2JGYndbJ7Ke4PjnaOiUtqAj6XftjUeqxPqRDLuR-Jh1hzRg50TU3N4wA1rp0Xlh8139cDsEVz_OW40oRf2BY4xcY3VWh9rY6-EmOsAC2XWnlFbRzzAIO2H6aHW_52mMkzm64/s320/Lucid_Origin_A_highly_detailed_diagram_explaining_each_bone_in_069A.png" alt="Detailed Diagram" width="199" height="320" />
      </a>
    </div>

</div> <!-- Master Container Ends Here -->