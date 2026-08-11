---
layout: "@/layouts/Layout.astro"
title: "CODE"
---

<style>
  /* 1. The new Master Container that holds everything */
  .master-container {
    background-color: #b6cbe6;
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
<div style="display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 80px; margin-bottom: 2rem;">
  
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

</div>

<!-- START OF MASTER CONTAINER -->
<div class="master-container">

<!-- BANNER IMAGE -->
  <div style="text-align: center; margin-bottom: 2rem;">
    <img src="/code.png" alt="Code Banner" style="max-width: 800px; width: 100%; height: auto; transform: scale(1.0);" />
  </div>

  <!-- Clean HTML: Just the links and the images -->
  <div class="labs-columns">
    <!-- Math -->
    <a href="/tags/math" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjvepsIiVJEvlSZNdExpiO440lauHWpgpzHzpt3PqbDNw65EmSRxkyWn3cMdR0QPAmaW8JVZnPaSPsz78-JV6tMTpicI-ytYsneDbNYxh1sRiz-DBy0pWFy71SnE-vVcwC_E99UFN4Moo0xkU_CEQwDjg_APZ1xee2_Ov-And1zttfcYLJwBl1rRNv6LnI/s1600/Lucid_Origin_A_70s_retro_computer_science_lines_of_code_with_m_2.png" width="320" alt="Math" style="background-color: #000000;"/>
    </a>
    <!-- Lisp -->
    <a href="/tags/lisp" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgZePZPHDJM8EVtMzDnGKFlhQDi2-LJ33pUyqyfqdO1kK72a5h6JdU1DWlD8K0nSwIwPzu8N45l1LXGp9C1mypiZRur_xqiPUgX2qV-g6kynnOywcq1ohourJCXBdizjepOpC53bLgQ2QBCh5cO8WRYDhEu7TR_Ihf9Jb0kcznrYH2G0KYbbstPGDUWbMY/s1600/Lucid_Origin_A_70s_retro_computer_science_lines_of_code_from_L_3.png" width="278" alt="Lisp" style="background-color: #000000;"/>
    </a>
    <!-- Magma -->
    <a href="/tags/magma" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgKOdk-wft6FMOrxkFbciDV8d63F7aclW6eQSckKTZ25FJxfNtcAtW1SUacGbm_zuCS_025UxVKWxr-m1C0HXl3KwXvC1gzlc7JV1hoVELfORe5pppabvGgJ_xOFYUFU3pmg6CSSXNs1P-dDsn0pz2AeeYK9yGrUD3bTdW4kiCs4vkedVyULlr7mAlQ6rE/s1600/Lucid_Origin_A_70s_retro_computer_science_lines_of_code_with_m_0.png" width="320" alt="Magma" style="background-color: #000000;"/>
    </a>
    <!-- Python -->
    <a href="/tags/python" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhHPwGHTO9uBeLPCIGQVs67NJaVcaQ9pvRiDVorPGRWUOHS3HrPUVIVGKpWkyRiChsDFlcmrFO-6I6Hq55Tom14FlVIe8e5bAKJNoBWe25YOpb_M8vPSFE5t1pGGKH9CVywBDZUZ-vWKC7ag6L3fMWzj8LlsHGny1DhWLSMCN7SwpEuYjUNmJbTreUfyR8/s1600/Lucid_Origin_A_70s_retro_computer_science_lines_of_code_from_L_0.png" width="183" alt="Python" style="background-color: #000000;"/>
    </a>
    <!-- Bash -->
    <a href="/tags/bash" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj7vISB5h_sjpTdmY3RdfbOMNQjWakTQCk_k2WS1oRD3SF9PYRdMiY9Hya8lX-zXS4CmqxvO0PrnPmrLftwEyBiF-GGRIiXcYle0Xr26dysVKTgPr7bkjWL8aZFgDvMeaotWLtDa5Q6chIvcV-kF37q48hmjyxF9RYPV2HSgKnwJxvYnj1j4c3aZVLuJP8/s1600/bash.png" width="168" alt="Bash" style="background-color: #000000;"/>
    </a>
    <!-- Sage -->
    <a href="/tags/sage" class="image-wrapper">
      <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhxnp11w6xhoPAts2X2zuVkygHL5Oec1zFftVuV0dQy7TNNofzja2LGbxuPsLYq_cHJSKD027WXcIK2ULXEQ3srheaOmTs2v_aZX5MeN8LfILxsXIPoQb3LlvMghf2axY1ZO8BImKGELxBhx_Yp3dpcrpW2QVxtWeyMrQBADkFK9ib56hTWZ5OuBmUbNLM/s1600/Lucid_Origin_A_70s_retro_computer_science_lines_of_code_with_m_0(1).png" width="243" alt="Sage" style="background-color: #000000;"/>
    </a>

  </div> <!-- THIS CLOSES THE .labs-columns DIV -->

</div> <!-- CLOSES THE NEW .master-container DIV -->