---
  title: "Computational Musicology"
author: "John Ashley Burgoyne"
date: "2019"
output: 
  flexdashboard::flex_dashboard:
  storyboard: true
theme: lumen
---
  
  `r knitr::opts_chunk$set(cache = TRUE)`

```{r, cache = FALSE}
# In order to use these packages, we need to install flexdashboard, plotly, and Cairo.
library(tidyverse)
library(plotly)
library(spotifyr)
source('spotify.R')
```

### What kind of storyboard do I need to create?

Your portfolio will be a 5–10-page storyboard in the style of the R package [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/using.html#storyboards), using data from the [Spotify API](https://developer.spotify.com). Your storyboard should cover the following topics, but note that it is possible (and often desirable) for a single visualisation or tab to cover more than one topic.
                                                                                            
                                                                                            - **Background**: Which tracks did you choose? Why? What questions will the storyboard answer?
                                                                                              - **Track-level features**: What insights into your corpus can be drawn from Spotify’s track-level features (valence, danceability, etc.)?
                                                                                              - **Chroma features** [pitch]: What insights into your corpus can be drawn from Spotify’s chroma features?
                                                                                              - **Loudness** [volume]: What insights into your corpus can be drawn from Spotify’s ‘loudness’ (power) features, either at the track level or the section level?
                                                                                              - **Timbre features** [timbre]: What insights into your corpus can be drawn from Spotify’s timbre features?
                                                                                              - **Temporal features** [duration]: What is notable, effective, or ineffective about structural segments, metre, rhythm, or beats in your corpus, as derived from Spotify features?
                                                                                              - **Classification/regression**: Where explicit labels in your corpus exist, how strong are Spotify features for classification or regression?
                                                                                              - **Clustering**: Where explicit labels in your corpus are lacking, which Spotify features generate potentially meaningful clusters?
                                                                                              - **Contribution**: What have you learned from this set of analyses? Who could these conclusions benefit, and how?
                                                                                              
                                                                                              Depending on your topic, you may want to start with a text-based opening like this one; alternatively, you could put your most compelling visualisation directly on the first tab and just use the commentary to introduce your corpus and research questions.
                                                                                            
                                                                                            This storyboard contains further examples from each week to inspire you. For more detailed code examples from each week, check the [repository page](https://github.com/jaburgoyne/compmus2019) or use the following links for rendered R Markdown files.
                                                                                            
                                                                                            - [Week 8](compmus2019-w8.nb.html)
                                                                                            
                                                                                            
                                                                                            ***
                                                                                              
                                                                                              The grading breakdown for the portfolio is as follows. The rubric was adapted from the Association of American Colleges and Universities (AAC&U) Inquiry and Analysis and Quantitative Literacy [VALUE rubrics](https://www.aacu.org/value-rubrics).
                                                                                            
                                                                                            | Component        | Points |
                                                                                              |------------------|:------:|
                                                                                              | Corpus selection |      7 |
                                                                                              | Assumptions      |      7 |
                                                                                              | Representation   |      7 |
                                                                                              | Interpretation   |      7 |
                                                                                              | Analysis         |      7 |
                                                                                              | Presentation     |      7 |
                                                                                              
                                                                                              ### The Grammys are angrier than the Edisons [track-level features].
                                                                                              
                                                                                              ```{r}
                                                                                            grammy <- get_playlist_audio_features('digster.fm', '4kQovkgBZTd8h2HCM3fF31')
                                                                                            edison <- get_playlist_audio_features('spotify', '37i9dQZF1DX8mnKbIkppDf')
                                                                                            awards <-
                                                                                              grammy %>% mutate(playlist = "Grammys") %>%
                                                                                              bind_rows(edison %>% mutate(playlist = "Edisons"))
                                                                                            angry <-
                                                                                              awards %>%                   # Start with awards.
                                                                                              ggplot(                      # Set up the plot.
                                                                                                aes(
                                                                                                  x = valence,
                                                                                                  y = energy,
                                                                                                  size = loudness,
                                                                                                  colour = mode,
                                                                                                  label = track_name
                                                                                                )
                                                                                              ) +
                                                                                              geom_point(alpha = 0.8) +               # Scatter plot.
                                                                                              geom_rug(size = 0.1) +       # Add 'fringes' to show data distribution.
                                                                                              facet_wrap(~ playlist) +     # Separate charts per playlist.
                                                                                              scale_x_continuous(          # Fine-tune the x axis.
                                                                                                limits = c(0, 1),
                                                                                                breaks = c(0, 0.50, 1),  # Use grid-lines for quadrants only.
                                                                                                minor_breaks = NULL      # Remove 'minor' grid-lines.
                                                                                              ) +
                                                                                              scale_y_continuous(          # Fine-tune the y axis in the same way.
                                                                                                limits = c(0, 1),
                                                                                                breaks = c(0, 0.50, 1),
                                                                                                minor_breaks = NULL
                                                                                              ) +
                                                                                              scale_colour_brewer(         # Use the Color Brewer to choose a palette.
                                                                                                type = "qual",           # Qualitative set.
                                                                                                palette = "Dark2"       # Name of the palette is 'Paired'.
                                                                                              ) +
                                                                                              scale_size_continuous(       # Fine-tune the sizes of each point.
                                                                                                trans = "exp",           # Use an exp transformation to emphasise loud.
                                                                                                guide = "none"           # Remove the legend for size.
                                                                                              ) +
                                                                                              theme_light() +              # Use a simpler theme.
                                                                                              labs(                        # Make the titles nice.
                                                                                                x = "Valence",
                                                                                                y = "Energy",
                                                                                                colour = "Mode"
                                                                                              )
                                                                                            ggplotly(angry)
                                                                                            ```
                                                                                            
                                                                                            ***
                                                                                              
                                                                                              For this visualisation from Week 7, I took playlists of the pop music presented at the Grammy awards (US) and the Edison awards (NL) in 2019. Using `ggplotly`, the visualisation became interactive.
                                                                                            
                                                                                            The *x* axis shows valence and the *y* axis shows Spotify's ‘energy’ feature, which is roughly analogous to the notion of arousal in psychological research on emotion. Under this model, the quadrants of each graph, starting clockwise from the top left, reprsent angry, happy, relaxed, and sad music. The size of each point is proportional to the average volume of the track.
                                                                                            
                                                                                            The visualisation shows that in 2019, the pop music at the Grammys was (according to Spotify) rather angrier and rather louder than the music at the Edisons.
                                                                                            
                                                                                            ### The Tallis Scholars sing Josquin more slowly than La Chapelle Royale -- except for one part [chroma features].
                                                                                            
                                                                                            ```{r}
                                                                                            tallis <- 
                                                                                            get_tidy_audio_analysis('2J3Mmybwue0jyQ0UVMYurH') %>% 
                                                                                            select(segments) %>% unnest(segments) %>% 
                                                                                            select(start, duration, pitches)
                                                                                            chapelle <- 
                                                                                            get_tidy_audio_analysis('4ccw2IcnFt1Jv9LqQCOYDi') %>% 
                                                                                            select(segments) %>% unnest(segments) %>% 
                                                                                            select(start, duration, pitches)
                                                                                            maria_dist <- 
                                                                                            compmus_long_distance(
                                                                                            tallis %>% mutate(pitches = map(pitches, compmus_normalise, 'manhattan')),
                                                                                            chapelle %>% mutate(pitches = map(pitches, compmus_normalise, 'manhattan')),
                                                                                            feature = pitches,
                                                                                            method = 'aitchison')
                                                                                            ```
                                                                                            
                                                                                            ```{r}
                                                                                            maria <- 
                                                                                            maria_dist %>% 
                                                                                            mutate(
                                                                                            tallis = xstart + xduration / 2, 
                                                                                            chapelle = ystart + yduration / 2) %>% 
                                                                                            ggplot(
                                                                                            aes(
                                                                                            x = tallis,
                                                                                            y = chapelle,
                                                                                            fill = d)) + 
                                                                                            geom_tile(aes(width = xduration, height = yduration)) +
                                                                                            coord_fixed() +
                                                                                            scale_x_continuous(
                                                                                            breaks = c(0, 60, 105, 150, 185, 220, 280, 327), 
                                                                                            labels = 
                                                                                            c(
                                                                                            'Ave Maria',
                                                                                            'Ave cujus conceptio',
                                                                                            'Ave cujus nativitas',
                                                                                            'Ave pia humilitas',
                                                                                            'Ave vera virginitas',
                                                                                            'Ave preclara omnibus',
                                                                                            'O Mater Dei',
                                                                                            ''),
                                                                                            ) +
                                                                                            scale_y_continuous(
                                                                                            breaks = c(0, 45,  80, 120, 145, 185, 240, 287), 
                                                                                            labels = 
                                                                                            c(
                                                                                            'Ave Maria',
                                                                                            'Ave cujus conceptio',
                                                                                            'Ave cujus nativitas',
                                                                                            'Ave pia humilitas',
                                                                                            'Ave vera virginitas',
                                                                                            'Ave preclara omnibus',
                                                                                            'O Mater Dei',
                                                                                            ''),
                                                                                            ) +
                                                                                            scale_fill_viridis_c(option = 'E', guide = "none") +
                                                                                            theme_classic() + 
                                                                                            theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
                                                                                            labs(x = 'The Tallis Scholars', y = 'La Chapelle Royale')
                                                                                            # ggsave('maria.png', maria, width = 13, height = 8, dpi = 'retina')
                                                                                            maria
                                                                                            ```
                                                                                            
                                                                                            ***
                                                                                            
                                                                                            This visualisation of two performances of the famous ‘Ave Maria’ setting of Josquin des Prez uses the Aitchison distance between chroma features to show how the two performances align with one another. 
                                                                                            
                                                                                            For the first four stanzas, the relationship between the performances is consistent: the Tallis Scholars sing the piece somewhat more slowly than La Chapelle Royale. For the fifth stanza (*Ave vera virginitas*, starting about 3:05 into the Tallis Scholars’ performance and 2:25 into La Chapelle Royale’s), the Tallis Scholars singing faster than La Chapelle Royale, but at the beginning of the sixth stanza (*Ave preclara omnibus*, starting about 3:40 into the the Tallis Scholars’ performance and 3:05 into La Chapelle Royale’s) the Tallis Scholars return to their regular tempo relationship with La Chapelle.
                                                                                            
                                                                                            Although the interactive mouse-overs from `ggplotly` are very helpful for understanding heat maps, they are very computationally intensive. Chromagrams and similarity matrices are often better as static images, like the visualisation at left.
                                                                                            
                                                                                            Static images can sometimes also be useful to add content to your commentary, like the histogram of Aitchison distances below, labelled with the minimum, first quartile, median, third quartile, and maximum values in the data. You must save the images manually, however, and make sure to export them at a good size.
                                                                                            
                                                                                            ```{r}
                                                                                            maria_hist <- 
                                                                                            maria_dist %>% 
                                                                                            ggplot(aes(x = d)) +
                                                                                            geom_histogram(binwidth = 0.5) +
                                                                                            theme_classic() + 
                                                                                            theme(
                                                                                            axis.line.y = element_blank(), 
                                                                                            axis.ticks.y = element_blank(),
                                                                                            axis.text.y = element_blank()) +
                                                                                            scale_x_continuous(breaks = c(0.7, 4.4, 5.5, 6.8, 14.2)) +
                                                                                            labs(x = 'Aitchison Distance', y = '')
                                                                                            ggsave("maria_hist.png", maria_hist, width = 3, height = 2, dpi = 'screen')
                                                                                            ```
                                                                                            
                                                                                            ![](maria_hist.png)