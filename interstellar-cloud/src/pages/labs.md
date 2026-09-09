---
layout: "@/layouts/Layout.astro"
title: "LABS"
---

<style>
  /* 1. The new Master Container that holds everything */
  .master-container {
    background-color: #cbd5e1;
    max-width: 950px;
    margin: 0rem auto; /* Centers the whole block horizontally on the page */
    padding: 1rem 1rem; /* Space inside the grey box so content breathes */
    border-radius: 8px; /* Optional: slightly rounds the grey box corners */
  }

  /* 2. Grid layout for the main game images (forces left-to-right order) */
  .labs-columns {
    display: grid;
    grid-template-columns: repeat(2, 1fr); 
    gap: 5rem;
    max-width: 800px; /* Shrunk slightly to fit neatly inside master container */
    margin: 2rem auto;
    padding: 0 2rem;
    align-items: center; 
    justify-items: center; 
  }

  /* 3. Centers the 5th (odd) image perfectly across both columns */
  .labs-columns .image-wrapper:last-child:nth-child(odd) {
    grid-column: 1 / -1; 
  }

  /* 4. Base styles for the image links */
  .image-wrapper {
    display: block;
    text-align: center;
  }

  /* 5. Side-by-side layout for the bottom two images */
  .bottom-row {
    display: flex;
    flex-wrap: wrap;       
    justify-content: center; 
    align-items: center;   
    gap: 3rem;             
    margin-top: 5rem; /* Creates the empty space above them */
    margin-bottom: 4rem;
    max-width: 800px;
    margin-left: auto;
    margin-right: auto;
  }
  
  .bottom-row .image-wrapper {
    margin-bottom: 0;      
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

  <a href="/code" style="font-family: monospace; font-weight: 800; font-size: 1.0rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;">
    [CODE]
  </a>

</div>
<!-- START OF MASTER CONTAINER -->
<div class="master-container">
  <!-- BANNER FIX: Added max-width: 800px so it stops expanding -->
  <div style="text-align: center; margin-bottom: 2rem;">
    <img src="/_labs.png" alt="Labs Banner" style="max-width: 800px; width: 100%; height: auto; transform: scale(1.0);" />
  </div>

  <!-- Clean HTML: Just the links and the images -->
  <div class="labs-columns">
    <!-- Nim -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-1" class="image-wrapper">
      <img src="/nim.png" width="220" alt="Nim" style="background-color: #000000;"/>
    </a>
    <!-- Wuzi Qi -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-3" class="image-wrapper">
      <img src="/wuzi_qi.png" width="238" alt="Wuzi Qi" style="background-color: #000000;"/>
    </a>
    <!-- Goofspiel -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-2" class="image-wrapper">
      <img src="/goofspiel.png" width="255" alt="Goofspiel" style="background-color: #000000;"/>
    </a>
    <!-- Dots and Boxes -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-4" class="image-wrapper">
      <img src="/dots_and_boxes.png" width="229" alt="Dots and Boxes" style="background-color: #000000;"/>
    </a>
    <!-- Dawson's Kayles -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-5" class="image-wrapper">
      <img src="/dawsons_kayles.png" width="312" alt="Dawson's Kayles" style="background-color: #000000;"/>
    </a>
    <!-- Hackenbush -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-6" class="image-wrapper">
      <img src="/hachenbush.png" width="250" alt="Hackenbush" style="background-color: #ffffff;"/>
    </a>
    <!-- Domineering -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-7" class="image-wrapper">
      <img src="/domineering.png" width="250" alt="Domineering" style="background-color: #ffffff;"/>
    </a>
    <!-- Gale -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-8" class="image-wrapper">
      <img src="/gale.png" width="250" alt="Gale" style="background-color: #ffffff;"/>
    </a>
    <!-- Shannon Switching -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-9" class="image-wrapper">
      <img src="/shannon.png" width="250" alt="Shannon Switching" style="background-color: #ffffff;"/>
    </a>
    <!-- Hex -->
    <a href="/posts/2026-07-02-mars-symplecticum-chapter-10" class="image-wrapper">
      <img src="/hex.jpg" width="250" alt="Hex" style="background-color: #ffffff;"/>
    </a>

  </div> <!-- THIS CLOSES THE .labs-columns DIV -->
  
  <div style="height: 60px;"></div>
  
  <!-- NEW SIDE-BY-SIDE CONTAINER -->
  <div class="bottom-row">
    <!-- Soundcloud / Sappho -->
    <a href="https://soundcloud.com/aubrie-fisher-1?p=a&c=1&si=d9fad7464e204d8f91d965ed72128f19" target="_blank" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgyEdX7qyre13yyO4AZsMA6FwprtsGSaIgf0LOGQ-_Ascg3MN-FImt5Pg-a4jvtfN8VcqbIPTfcn38KBEzzWqsp7Hivf0eK9PZbOiPBWCK6arV-pf_6dVjXJC5aBKYL52fVWRmVrFqdJ8m1lTVP9F4oJfFknUiWF9_AjL4b2TbS77-ZDuaav__0SniLNw4/s320/512px-1877_Charles_Mengin_-_Sappho.png" width="219" alt="Soundcloud Audio" />
    </a>
    <!-- Code / LISP Script -->
    <a href="/code" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi2tfqRPGD-FPr05F-NFJ5tPf9fuHrDubVW_DOR8DTa-fobXnU_QKub6pMWQP2c5CFXnRqs_NO7vTvqRTcMofUQ00jg93n6vvXAZb0JfRUFvEa8MxxFFdoZc8viQuPvNRBzMY7KxsUPG9tqt2RtgKRmwyL2wDhIbpDPIkD56-W7ysXd1eR_VXReJ06zJuM/s320/Lucid_Origin_10_lines_of_LISP_script_with_blue_and_purple_synt_0.png" width="320" alt="LISP Script" />
    </a>

  </div> <!-- CLOSES THE .bottom-row DIV -->

</div> <!-- CLOSES THE NEW .master-container DIV -->
<footer style="margin-top: 4rem; padding: 2rem 0; text-align: center; border-top: 1px solid #cbd5e1; background-color: transparent;">
  
  <div style="color: #64748b; font-size: 0.9rem; font-family: system-ui, -apple-system, sans-serif;">
    <span>Copyright &#169; 2026</span>
    <span style="margin: 0 0.5rem;">|</span>
    <span>All rights reserved.</span>
  </div>
  
  <!-- Social Icons -->
  <div style="margin-top: 1rem; display: flex; justify-content: center; gap: 1.5rem;">
    <!-- GitHub Icon -->
    <a href="https://github.com/jerodmichel" target="_blank" style="color: #475569; transition: color 0.2s;" aria-label="GitHub">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 22v-4a4.8 4.8 0 0 0-1-3.02c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A4.8 4.8 0 0 0 9 18v4"/>
        <path d="M9 18c-4.51 2-5-2-7-2"/>
      </svg>
    </a>
    <!-- LinkedIn Icon -->
    <a href="https://www.linkedin.com/in/jerod-michel-26399933/" target="_blank" style="color: #475569; transition: color 0.2s;" aria-label="LinkedIn">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/>
        <rect width="4" height="12" x="2" y="9"/>
        <circle cx="4" cy="4" r="2"/>
      </svg>
    </a>
    <!-- Email Icon -->
    <a href="/contact" style="color: #475569; transition: color 0.2s;" aria-label="Contact">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="2" y="4" width="20" height="16" rx="2"/>
        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
      </svg>
    </a>
  </div>
</footer>