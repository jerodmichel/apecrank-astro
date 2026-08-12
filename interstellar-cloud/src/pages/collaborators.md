---
layout: "@/layouts/Layout.astro"
title: "Collaborators"
---

<style>
/* Reset and Header Hiding */
header, .header, .blog-title, .title { display: none !important; }
body { padding-top: 0 !important; }
#main-content { padding-top: 0; }

/* Link Styling */
a:link, a:visited { color: #60a5fa; text-decoration: none; }
a:hover { color: #c084fc; text-decoration: underline; }

/* The Master Container */
.page-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 0 20px 40px 20px;
}

/* Typography for Names */
.collaborator-name {
    color: #999999;
    font-size: 2em;
    font-weight: bold;
    margin: 0 0 1rem 0;
    line-height: 1.2;
}

/* Profile Block Layout (Image left, text right) */
.collaborator-block {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    margin: 4rem 0 2rem 0;
}

/* Profile Pictures */
.profile-pic {
    width: 180px;
    height: auto;
    flex-shrink: 0;
    border-radius: 4px;
}

/* Grid for the artwork/documents below bios */
.grid-2-col { 
    display: grid; 
    grid-template-columns: 1fr 1fr; 
    gap: 2rem; 
    justify-items: center;
    align-items: end; 
    margin: 3rem 0; 
}

/* Blockquote styling for the Whorf quote */
blockquote {
    border-left: 4px solid #60a5fa;
    padding-left: 1.5rem;
    margin: 2rem 0;
    font-style: italic;
    color: #99a1af;
}

/* Profile Pictures */
.profile-pic {
    width: 150px; 
    height: auto;
    flex-shrink: 0;
    border-radius: 4px;
}

@media (max-width: 600px) {
  div[style*="gap: 60px"] {
    flex-wrap: nowrap !important;
    gap: 15px !important;
  }
  
  div[style*="gap: 60px"] a {
    font-size: 0.75rem !important;
    white-space: nowrap !important;
  }
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
<div class="page-container" style="--text-nudge: 0px; background-color: #f1f5f9;">

<h1 class="text-left !text-4xl font-bold mb-16 !text-gray-400 pt-8">Collaborators</h1>

<!-- JEROD MICHEL -->
<div class="collaborator-block">
<img class="profile-pic" src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi8lcOr4OA1mOPRXJC2H1oOCqpW7oSfqJ1u9kmvZE0_HqGH2mDaK5reDk7kb5brmDIkJDc3B8o81s2bbYlbsCMeSyrJ0pVupzO3L1hiIxTfG9bjjiHcdyUZzQNQ_siqhf0j3kXLBWX9xf4/s200/IMG_6017.JPG" alt="Jerod Michel" />
<div style="text-align: left; margin-left: var(--text-nudge);">
<div class="collaborator-name">Jerod Michel, PhD, Editor</div>
<p>Jerod Michel's interests include combinatorics, information theory and linguistics. He is currently a Lecturer (TT) at Nanjing University of Aeronautics and Astronautics in Nanjing, China. (<a href="https://scholar.google.com/citations?user=Fky9K5EAAAAJ&hl=en&oi=ao" target="_blank">Google Scholar</a>, <a href="https://www.linkedin.com/in/jerod-michel-26399933" target="_blank">LinkedIn</a>)</p>
<blockquote>
The familiar saying that the exception proves the rule contains a good deal of wisdom, though from the standpoint of formal logic it became an absurdity as soon as "prove" no longer meant "put on trial." The old saying began to be profound psychology from the time it ceased to have standing in logic. What it might well suggest to us today is that, if a rule has absolutely no exceptions, it is not recognized as a rule or as anything else; it is then part of the background of experience of which we tend to remain unconscious. Never having experienced anything in contrast to it, we cannot isolate it and formulate it as a rule until we so enlarge our experience and expand our base of reference that we encounter an interruption of its regularity. The situation is somewhat analogous to that of not missing the water till the well runs dry, or not realizing that we need air till we are choking.<br /><br />
— Benjamin Lee Whorf
</blockquote>
</div>
</div>

<!-- Jerod's 4 Image Grid -->
<div class="grid-2-col">
<a href="http://staff.ustc.edu.cn/~drzhangx/group-chn/dcc/pdfs/Incidence%20structures%20related%20to%20difference%20sets%20and%20their%20applications.pdf" target="_blank">
<img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiZFfVuS6t2ubntWyFVeWlMsZAc8qtgsds3GNCCuWFrqkmr_Z1-kgwZjPB95dC7lQ0F0Yp2jivx0-lGlesc0cvUXXaNDwfpqPAASVskKrgaKD4p4nD3LGjEjBMXtsAISOHNz3oxvWynm56KMct9B1asxdX2XsTpw9x7Agmt7rIX_LgPDPI9kojiBFX9lW8/s320/Lucid_Origin_A_closeup_of_a_worn_leatherbound_spell_book_posit_2.png" width="301" alt="Difference Sets" style="background-color: #000000;"/>
</a>
<a href="https://issuu.com/contextolibre" target="_blank">
<img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjXzToL8PtusUw7GJ3Sh99s8JWkRm97-VJE2cPmiP5sXpbwEDgDhLQF66NO2makpPP0CHuSwuleJIDCZ2YTULfUGJzFgD8l7V-Y2RBTnF3pP7pYihjiK8HFFqWUXHK_0uxfOde4tNNlVsQTX8DFUkpwfB2WL5QISUDTnVhin8LWnvPsbpe9mrEasoxLMCY/s320/Lucid_Origin_A_closeup_of_straight_forward_futuristic_computer_2.png" width="268" alt="Futuristic Computer" style="background-color: #000000;"/>
</a>
<a href="/michel_resume">
<img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEikoD0PceqbG1wov750YKcGpmw9DjXfJjAAVcEq1FqPHjla-7TMaPAPMKYCOq3zqWyHeZo4zfwi2z1giveOkvamI-QIfBtmXJ5G3kUS2asvKYtIwVxpbbAdmG4DNk_GMxnClshpDoXla8MuvzmUs3QhDZTvLOkAgjZIn8bGDwdViQvO0a-_iDgq6dwcco0/s320/Lucid_Origin_A_detailed_clay_tablet_inscribed_with_ancient_Sum_1.png" width="205" alt="Clay Tablet" style="background-color: #000000;"/>
</a>
<a href="/publications">
<img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQaViKeKSwxy4oIBVQQ66dHobYx9pH4GZh8RnakQEfszvBqOIScWwcLezU_9pmf-ltlmUXdOMqYKF2b7VFc7Vn-Hg4mer-1OTphlePrGgh3UpUNibcVy3vJ06BUnSh-Dv0EEOJFsDATEbG9lPIfaMs6vuUWLjRQPSvVShbjV8gzo-IW_61JNolbbf_haQ/s320/Lucid_Origin_A_dramatic_closeup_portrait_of_a_cloaked_and_hood_3.png" width="259" alt="Cloaked Portrait" style="background-color: #000000;"/>
</a>
</div>

<hr style="border: 0; border-top: 1px solid #333; margin: 4rem 0;" />

<!-- GAO RONG -->
<div class="collaborator-block">
<img class="profile-pic" src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiAy7XSvKYb7TOZs7-d1CzTkLNompCeJOPdSK9QDDSvOmQkP15WXlJ6bryf2kBFUmvqCi4uaXiZUAwsIX6OxV9NTT9K-M8mw7LLwZulLxSnKrNmuGNbXtWI6je-5dKhudrV69VsD0rQ2Wm-D2TEw9li1V0M8lGJecCfkIoPy2o_a96MK14D3nbItM2v5vs/w138-h138/46a68e_f34f5eb010204fc5ab5855e869ac7ff4~mv2.jpg" alt="Gao Rong" />
<div style="text-align: left; margin-left: var(--text-nudge);">
<div class="collaborator-name">Gao Rong, Editor</div>
<p>Gao Rong is a multifaceted editor whose career bridges human resources, international education, and literary curation. She brings her sharp eye for detail and linguistics talent to the acclaimed project <a href="https://www.amazon.com/Notes-China-Jerod-Michel-PhD/dp/B0D2YW531Y">"Notes from China"</a>, published by Hyperion Academic &amp; Tech, LLC, and the science fiction novel, <a href="https://www.amazon.com/Witches-Rascar-Pablo-Kristopher-Lawrence/dp/B0CWTWSCP6"><i>Witches of Rascar Pablo</i></a>, also published by Hyperion, and available to read at no cost for a limited time <a href="https://theweirdcrap.com/alarmingly-strange-stories/the-witches-of-rascar-pablo-the-complete-novel/">here</a>.</p>
<p>Her professional foundation is built on over eight years of leadership in HR and recruiting within international education, currently serving as the Director of Human Resources for Times Education (Nanjing). A certified HR professional holding both Parts I and II of the Chinese National Human Resources Qualification; she began her career after earning a BA in English Literature from Nanjing University of Information Science and Technology.</p>
<p>Gao Rong leverages her bilingual expertise as an English-Mandarin translator and interpreter, skills that deeply inform her editorial work and her strategic approach to fostering international partnerships.</p>
<p><strong>Gao Rong's office is currently located in Nanjing, Jiangsu (China).</strong><br />
For more about Gao Rong visit her <a href="https://www.linkedin.com/in/%E9%AB%98%E8%93%89-gao-rong-52121447/?miniProfileUrn=urn%3Ali%3Afs_miniProfile%3AACoAAAnR9ukBYNH4ep-Y1-3H0EULUKtepEfnpIw" target="_blank">LinkedIn Profile</a>.</p>
</div>
</div>

<hr style="border: 0; border-top: 1px solid #333; margin: 4rem 0;" />

<!-- KRISTOPHER LAWRENCE -->
<div class="collaborator-block">
<img class="profile-pic" src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj_jHaSlqnL0vHv5B2NyB-1HL7rrDSBnFmgyhGnlAk6VtMq93kVC4Un3PKo_Q3_D6pk8AV-1Z7JmT4SCddXqO4FfhdxMypcgU2TK4rMrMO4LPY_HdsqrtYu2pjDt9rRoqk3-crjliCTPUKMe2gPTE_AZoNSSbL4gijtR9XkVJ8U6HI_C_kO-H2O8kMe7CI/s1808/Lucid_Origin_A_candid_photograph_of_30yearold_homeless_man_wit_3.jpg" alt="Kristopher Lawrence" />
<div style="text-align: left; margin-left: var(--text-nudge);">
<div class="collaborator-name">Kristopher Lawrence, Narrative Designer</div>
<p>Kristopher Lawrence is a writer and amnesiac who turned up in Oregon—seemingly out of nowhere—one day in the Summer of 2025; he was talking with a stutter and looking like he had just shaved his own head, since there were many spots that he missed. He remembers having a designated drinking-and-driving car at one point in his life, which may have been a VW Diesel Rabbit, and probably looked like a crumpled up piece of tin foil. If you or anyone you know has any information regarding Kris's origins, please contact us. Kristopher is the author of the science fiction novel, <a href="https://www.amazon.com/Witches-Rascar-Pablo-Kristopher-Lawrence/dp/B0CWTWSCP6"><i>Witches of Rascar Pablo</i></a>, which is published by Hyperion Academic & Tech, LLC, and is available to read at no cost for a limited time <a href="https://theweirdcrap.com/alarmingly-strange-stories/the-witches-of-rascar-pablo-the-complete-novel/">here</a>.</p>

<p style="margin-top: 1rem;">
      <a href="/posts/transmission" style="font-family: monospace; font-weight: 800; font-size: 0.95rem; color: #006688; text-decoration: none; letter-spacing: 0.1em; transition: opacity 0.2s;" class="hover:opacity-70">
        [READ "INTERCEPTED TRANSMISSION: TAU-047-23-B" by K. LAWRENCE]
      </a>
    </p>

</div>
</div>

<hr style="border: 0; border-top: 1px solid #333; margin: 4rem 0;" />

<!-- BILLY HILL -->
<div class="collaborator-block">
<img class="profile-pic" src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgRazYsCERksYjsFz9LPbmGuCFU-obevxy3djzb_tOkAPUGTczzqB-Ka3lJg7Cs_lWpWy_pIGE9kguhFV05ag4wwpyIbkbKjrz7YxymTjpkX1qzMWuu_JvJl5psmIKoBHbdyY0j3JRSWy6hhIslqLDb99oo5eXgEpO6uxUMvwhTSyr3n6ML9SKhyNbVCGg/s200/Lucid_Realism_a_youthful_white_male_with_a_strong_resemblance__0.jpg" alt="Billy Hill" />
<div style="text-align: left; margin-left: var(--text-nudge);">
<div class="collaborator-name">Billy Hill, Graphic Designer</div>
<p>Billy Hill is 25 years old, but he is from the year 1974. He was catapulted here after a fateful encounter with an extraterrestrial psychedelic.</p>
<p>His art is a direct portal to his past, and he navigates the modern world in a sense of awe and confusion—mostly confusion—and perpetually searches for the sights and sounds of his own time. These include 8-track players, and women wearing bell bottoms and patchouli. <br><br>
Billy contributed to the project <a href="https://www.amazon.com/Notes-China-Jerod-Michel-PhD/dp/B0D2YW531Y">"Notes from China"</a>, published by Hyperion Academic &amp; Tech, LLC, and did the cover art for the novel <a href="https://theweirdcrap.com/alarmingly-strange-stories/the-witches-of-rascar-pablo-the-complete-novel/">"Witches of Rascar Pablo"</a>.</p>
</div>
</div>

<!-- Billy's 2 Image Grid -->
<div class="grid-2-col">
<a href="https://www.instagram.com/billyhill9999?igsh=MTF4MXFjMWJxNHhiYQ==" target="_blank">
  <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgAbD7H_SvtMInVyhnm2Fj9gUsZ6bHOU8aHLFYLecxjFFnwoHJKWLmgwaJFFBs3nTFbU9X_mX6_Zvxl7SMh6q0M7ND72TgH0PssEdPoXr8bk_czniYSqxwELJD0CqF_eRepxzi0zvqKyQPab1zPEzQFfjJtbDYeqsCgRo3WPvgpKUnE0INHPOiZGSPzRpQ/s1600/Lucid_Origin_oil_painted_in_the_style_of_Zdzisaw_Beksiski_the__3.png" width="221" alt="Beksinski Style Painting" style="background-color: #9ca3af;" />
</a>
<a href="/days-in-china">
<img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgL-x4Jnt3P2B4Gu8pEYGydVjsclPgX5yg1GwSy4MkLYwh3fdKvohaH5HqIFa9g8JjKRazs5LYtQXRMIhPUGRrZHNacHZXYgjKIOdQzh8VNx9G1g3_JVyAq46VG8rxq0Nxpti5arEm4qzrst0MfDy-Bbbmepr79LlwPMe5IvKzR2wNL0zSmueR4xZiOnwo/w320-h318/Lucid_Origin_Chinese_warrior_with_determined_facial_features_d_2_C.png" width="320" alt="Chinese Warrior" />
</a>
</div>

</div> <!-- Master Container Ends Here -->