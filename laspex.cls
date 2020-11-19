%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{laspex}[2020/11/16]

\LoadClass{article}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Packages and global stuff
\RequirePackage[utf8]{inputenc}
\RequirePackage{needspace}      % To manage page breaking
\RequirePackage{ifthen}	        % Enables if's and else's
% \RequirePackage{etoolbox}     % Funderar på att fasa ut ifthen mot etoolbox
\RequirePackage{fancyhdr}
\RequirePackage[yyyymmdd]{datetime}
\RequirePackage[normalem]{ulem}         % Provides styles for instructions
\RequirePackage[flushmargin]{footmisc}  % Flushes content in page footer etc.
\RequirePackage{fancybox}        % Used for nice-looking music box
\RequirePackage{environ}

\def\actprint{Act}
\def\sceneprint{Scene}
\def\pageprint{Page}

\newif\if@swedish
\newif\if@instructions
\newif\if@book
\newif\if@inspicio % Bool for stage mananger
\newif\if@scenery
\newif\if@onepages
\newif\if@entrances

\@bookfalse
\@swedishtrue
\@instructionstrue
\@inspiciotrue
\@scenerytrue
\@onepagestrue
\@entrancestrue

% If option on
\DeclareOption{book}{\@booktrue\@twosidetrue\@sceneryfalse\@entrancesfalse}
\DeclareOption{swedish}{\@swedishtrue}
\DeclareOption{english}{\@swedishfalse}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Options
% Definiera option att ta bort scenhänvisningar
\DeclareOption{utan-instruktioner}{\@instructionsfalse}
\DeclareOption{med-instruktioner}{\@instructionstrue}

% Definiera option att ta bort in- och utgångar samt teknikinstruktioner
\DeclareOption{utan-teknik}{\@sceneryfalse}
\DeclareOption{med-teknik}{\@scenerytrue}

\DeclareOption{med-onepages}{\@onepagestrue}
\DeclareOption{utan-onepages}{\@onepagesfalse}
\DeclareOption{with-entrances}{\@entrancestrue}
\DeclareOption{without-entrances}{\@entrancesfalse}


\ProcessOptions\relax

%%% Important lengths
\newlength{\sepreplik}                  % Till repliker
\newlength{\vreplik}

\if@book\setlength{\vreplik}{20mm}\else\setlength{\vreplik}{0.3in}
\addtolength{\vreplik}{0.7in}\fi
\setlength{\sepreplik}{\vreplik}
\addtolength{\sepreplik}{-0.1in}

\newlength{\tempwidth}\setlength{\tempwidth}{133mm}\addtolength{\tempwidth}{-\vreplik}
\newlength{\templeft}\setlength{\templeft}{18.5mm}\addtolength{\templeft}{\vreplik}

\if@book\RequirePackage[a4paper,
 textwidth=\tempwidth,
 voffset=0mm,
 textheight=185mm,
 hoffset=0mm,
 headsep=12pt,
 paperheight=240mm,
 footskip=26pt,
 paperwidth=170mm,
 left=\templeft,
 top=26mm,
% bottom=2in,
% bmargin=1in,
% marginparsep=0.2in,   % Distance between character and line.
]{geometry}%
\else\RequirePackage[a4paper,
 left=1.9in,
 top=1in,
 headsep=0.15in,
 bottom=2in,
 bmargin=1in,
 marginparwidth=1.1in,
 textwidth=4.65in,
 marginparsep=0.2in,            % Distance between character and line.
 footskip=30pt
]{geometry}\fi

\newlength{\musicboxl}
\setlength{\musicboxl}{\textwidth}
\if@book\addtolength{\musicboxl}{\vreplik}\fi

\setlength{\parindent}{0pt}     % Removes indents in the beginning of paragraphs
\pagestyle{fancy}               % Enable headings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Counters, counters are set to zero upon creation
\newcounter{pagecounter_help}
\newcounter{pagecounter_help2}
\newcounter{actcounter}
\newcounter{scencounter}
\setcounter{scencounter}{1}
\newcounter{subscenecounter}
\newcounter{paragraphsOnPage}[page]     % set to zero each time page is updated
\newcounter{scenesOnPage}[paragraph]    % Try also scene

%%% Lengths (should be removed and defined when used?)
\newlength{\tmpl}                       % For subscenes
\newlength{\tmpM}                       % For subtitle music
\newlength{\tmpE}                       % For eller-title

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Language selection
\if@swedish%
\def\actprint{Akt}%
\def\sceneprint{Scen}%
\def\pageprint{Sida}%
\RequirePackage[swedish]{babel}\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Headers and footers
\if@book\else\renewcommand{\headrulewidth}{0pt}\fi% Removes header horizontal line.

\newcommand{\headertext}[1]{\bf{\footnotesize #1}}
\if@book\font\eightbf=cmbx8\renewcommand{\headertext}[1]{{\eightbf #1}}\fi

%%% Common header and footer
\fancyhf{}
\rhead{%
    \headertext{\spextitel{}}%
    \settowidth{\tmpE}{\ellertitel{}}%
    % If tmpE is empty, do nothing, otherwise, print out eller-title
    \ifnum\tmpE>0\headertext{ -- eller \ellertitel}\fi%
    \setcounter{pagecounter_help2}{\value{page}}%
    \addtocounter{pagecounter_help2}{-\value{pagecounter_help}}%
    \addtocounter{pagecounter_help2}{1}%
    \mbox{%
        \hspace{\marginparsep}\parbox[b]{20mm}%
        {\scenfont{\pageprint{} \arabic{actcounter}.\arabic{pagecounter_help2}}}}%
    \hspace{-\marginparsep}\hspace{-20mm}%
}
\lhead{\footnotesize\bf{\actprint{} \theactcounter}}
\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}

\if@book\fancyhf{}%
        \fancyheadoffset[lh]{\vreplik}%
        \fancyhead[RO]{\footnotesize\bf{\korttitel{} \theactcounter:\thescencounter}}%
        \fancyhead[LE]{\footnotesize\bf{\spextitel{}}}%
        \fancyfootoffset[lf]{\vreplik}%
        \fancyfoot{\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern5pt\arabic{page}\kern5pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill}{\fi

%%% Front page header and footer
\fancypagestyle{framsida}{
    \def\SPeX{S\kern-.125em P\kern-.1667em \lower.5ex\hbox{E}\kern-.125em X}
    \def\LaSPeX{L\kern -.36em \raise.5ex\hbox{A}\kern -.15em\SPeX}
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}
    \if@book\else\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}
    \rfoot{\footnotesize \parbox[b]{65mm}{Skrivet i Jesper \LaSPeX-mall,\\ klart inspirerat utav Grodans \SPeX-mall}}\fi
}

%%% Character page header and footer
\fancypagestyle{karaktarsida}{%
    \fancyhf{}%
    \if@book\fancyheadoffset[lh]{0pt}\else\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}%
    \rhead{\footnotesize\bf{\spextitel{}}%
        \settowidth{\tmpE}{\ellertitel{}}%
        \ifnum\tmpE>0\textrm{ -- eller}\bf{\ellertitel}\else\ignorespaces\fi%
        % Print page number
        \mbox{\hspace{\marginparsep}\parbox[b]{20mm}{Sida \thepage}}%
        \hspace{-\marginparsep}\hspace{-20mm}%
    }\fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Framsidan
\newenvironment{framsida}{
    \if@book\newgeometry{left=18.5mm,right=18.5mm}%
    \else\newgeometry{left=1.5in,right=1.5in}\fi
    \pagestyle{framsida}                    % Specifies header
    \centering
    {\Huge\spextitel}\                      % Title
    \settowidth{\tmpE}{\ellertitel{}}
    \ifnum\tmpE>0\bigskip                               % print out eller-title
    {\Large eller}\\
    \huge{\ellertitel}\else\ignorespaces\fi%
    \bigskip%
}
{\clearpage\setcounter{page}{1}}            % new page

%%% Karaktärsidan/rollbeskrivning
\newenvironment{karaktarsida}{
    \if@book\newgeometry{left=18.5mm,right=18.5mm}\fi%
    \pagenumbering{roman}
    \pagestyle{karaktarsida}
}
{\clearpage}                                % new page



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kommandon för repliker och scenanvisningar

% Replik
\newcommand{\replik}[1]{\vspace{2mm}\Needspace{24pt}%
    \hspace{-\vreplik}%
    \mbox{%
        \parbox[b]{\sepreplik}{\raggedright\bf{#1:}}}%
        \hspace{7pt}\ignorespaces}%
% Fortsätt replik
\newcommand{\forts}{\vspace{2mm}\Needspace{24pt}\ignorespaces}
% För att markera nya repliker
\newcommand{\nytt}[1]{#1\marginpar{\texttt{NYTT!!!}}}
% För att markera strukna repliker
\newcommand{\struket}[1]{\sout{#1}\marginpar{\normalsize{\texttt{Struket}}}}

%%% In- och utgång samt rekvisita
\newcommand{\stageInstruction}[2]{%
        \if@entrances\vspace{2mm}\Needspace{24pt}{\uwave{#1}}%
        \marginpar{\texttt{#2}}\else\ignorespaces\fi}
% Ingång
\newcommand{\ingang}[1]{\stageInstruction{#1}{Ingång}}
% Utgång
\newcommand{\utgang}[1]{\stageInstruction{#1}{Utgång}}
% Dekor, rekvisita och teknik
\newcommand{\dekor}[1]{%
    \if@scenery\margintext{Dekor}{#1}\else\ignorespaces\fi}
\newcommand{\rekvisita}[1]{%
    \if@scenery\margintext{Rekvisita}{#1}\else\ignorespaces\fi}
\newcommand{\teknik}[1]{%
    \if@scenery\margintext{Teknik}{#1}\else\ignorespaces\fi}

% För beskrivning i sidfot till \dekor, \rekvisita, \teknik
\newcommand{\margintext}[2]{\if@scenery%
    \marginpar{\texttt{#1}}%
    \begingroup%
        \renewcommand\thefootnote{}\footnote{%
            \hspace{-0pt}%
            \mbox{%
                \hspace{-\vreplik}\parbox[b]{\sepreplik}%
                {\texttt{#1}}}%
            \hspace{7pt}#2%
        }%
        \addtocounter{footnote}{-1}
    \endgroup\else\ignorespaces\fi
}

%%% Scenanvisningar och kommentarer
%%% Dessa kan gömmas med valet utan-instruktioner i manus preamble:
% Scenanvisning
\newcommand{\scenanvisning}[1]{%
    \if@instructions\vspace{2mm}\Needspace{24pt}{\textit{#1}}%
	\else\ignorespaces\fi}
% Fortsätt scenanvisning på samma rad
\newcommand{\scenanvisningforts}[1]{%
    \if@instructions\nopagebreak{\textit{#1}}\else\ignorespaces\fi}
% Kommentarer
\newcommand{\kommentar}[1]{%
    \if@instructions\nopagebreak\small$\langle$\textit{#1}$\rangle$%
    \else\ignorespaces\fi} % If else, nothing (but ignore the space character)
% Hur
\newcommand{\hur}[1]{\kommentar{#1:}}
% Till:
\newcommand{\till}[1]{\kommentar{Till #1:}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% music box
%\musicbox{Title}{Singer}{What happens in the song}{Original
%           title}{Original composer}{Optional subtitle}
\newcommand{\musicbox}[6]{
    \medskip%
    \if@book\hspace{-\vreplik}\fi%
    \doublebox{%
    \vbox{%
        \hbox{\parbox[t]{0.8\musicboxl}{\small #2}}%
        \medskip%
        \setlength{\tempwidth}{\musicboxl}%
        \addtolength{\tempwidth}{-10pt}%
        \hbox{\makebox[\tempwidth][c]{\Large\bf{#1}}}%
        \settowidth{\tmpM}{#6}% Test if subtitle exists
        \ifnum\tmpM>0%
            \smallskip\hbox{\makebox[\tempwidth][c]{#6}}\fi
        \smallskip%
        \hbox{\makebox[\tempwidth][c]{({\textit{#4/#5}})}}%
        \medskip%
        \hbox{\parbox[t]{\tempwidth}%
            {\textit{\small #3}}}%
    }}%
\medskip}
\newcommand{\musikbox}[6]{\musicbox{#1}{#2}{#3}{#4}{#5}{#6}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scenes and acts
\newcommand{\actfont}[1]{{\Large\bf{#1}}}
\newcommand{\scenfont}[1]{{\bf{#1}}}

% Act
\newcommand{\act}[1]{%
    % To make line-breaking easier
    \obeylines              % A new line starts a new paragraph. Placed here
                            % because it doesn't work outside of a command
    % Create new page if not first act
    \ifnum\value{actcounter}>0 \newpage\else\ignorespaces\fi%
    \vspace{2mm}%
    \stepcounter{actcounter}%
    \setcounter{pagecounter_help}{\value{page}}%
    \setcounter{pagecounter_help2}{1}%
    \hspace{-\vreplik}\if@book\hfil\actfont{\actprint{} \arabic{actcounter}}\hfil\else%
    \parbox[b]{\sepreplik}%
    {\raggedright\actfont{\uppercase{\actprint{}} \arabic{actcounter}}}\hspace{7pt}\fi%
    \settowidth{\tmpM}{#1}%
    \ifnum\tmpM>0\if@book\par\medskip\hspace{-\vreplik}\hfill\actfont{#1}\hfill\else\actfont{#1}\fi%
    \else\par\fi
    \value{scencounter} = 0% Reset scene counter
    \everypar{\hangindent1em\hangafter1}%
    \smallskip%
}
\newcommand{\akt}[1]{\act{#1}}
% Scene
\newcommand{\scene}[1]{%
    \if@book\bigskip\else\enlinje\fi%
    \Needspace{72pt}%
    \stepcounter{scencounter}%
    \setcounter{subscenecounter}{0}%
    \hspace{-\vreplik}%
    \if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern5pt%
        \scenfont{\large\uppercase{\sceneprint} \arabic{actcounter}:\arabic{scencounter}}%
        \kern5pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{\large#1}\hfill%
    \else\parbox[b]{\sepreplik}%
    {\raggedright\scenfont{\uppercase{\sceneprint} \arabic{actcounter}.\arabic{scencounter}}}\hspace{7pt}\scenfont{#1}% Scene name
    \fi%
    \if@book\vspace{0mm}\else\vspace{2mm}\fi
}
\newcommand{\scen}[1]{\scene{#1}}

% Subscene/subscen
% First, no-star version
\newcommand{\subscennostar}[2]{%
    \if@book\bigskip\else\enlinje\fi%
    \Needspace{72pt}%
    % If this is the first subscen (within
    % a scene), increase scencounter
    \ifthenelse{\value{subscenecounter} = 0}%
    {\stepcounter{scencounter}}{}%
    \stepcounter{subscenecounter}%
    \hspace{-\vreplik}%
    \if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern5pt%
        \scenfont{\large\uppercase{\sceneprint} \arabic{actcounter}:\arabic{scencounter}\alph{subscenecounter}}%
        \kern5pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{\large#1}\hfill%
    \else\parbox[b]{\sepreplik}{%
        \raggedright\scenfont{%
            SCEN \arabic{actcounter}.\arabic{scencounter}%
            % Set tmpl to width of #2
            \settowidth{\tmpl}{#2}%
            % If tmpl is empty, use subscenecounter
            \ifthenelse{\lengthtest{\tmpl=0pt}}%
            % linebreak is to place linebreak if too wide.
            {\alph{subscenecounter}}{\linebreak[0]#2}%
        }%
    }\hspace{7pt}\scenfont{#1}\fi%
    \if@book\vspace{0mm}\else\vspace{2mm}\fi
}
% Starred version
\newcommand{\subscenstar}[2]{
    % If starred version, increment scenecounter and reset subscenecounter.
    \setcounter{subscenecounter}{0}%
    \subscennostar{#1}{#2}%
}
% Actually called command
\makeatletter
\newcommand\subscen{
\@ifstar\subscenstar\subscennostar}
\makeatother

% Definierar en linje, används av \scen och \subscen
\newcommand*{\enlinje}{
    \vspace{2mm}\cleaders\vbox to 0.4pt{\hrulefill}\vskip0.4pt\vspace{1mm}
}

% Definiera styrbord
\newcommand{\styrbord}[1]{\hfill\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \everypar{\hangindent1em \hangafter1}% Keep hang indentation
    \raggedleft#1\end{minipage}}
% Definiera babord
\newcommand{\babord}[1]{\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \everypar{\hangindent1em \hangafter1}% Keep hang indentation
    #1\end{minipage}}

% Definiera mittbord
\newcommand{\mittbord}[1]{\hspace*{\fill}\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \centering#1\end{minipage}\hspace*{\fill}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\NewEnviron{onepage}{%
\if@onepages%
\setlength{\tempwidth}{\textwidth}%
\if@book\addtolength{\tempwidth}{\vreplik}\fi%
\begin{figure}[p]\if@book\hspace{-\vreplik}\fi% 
\begin{minipage}[t][\textheight][t]{\tempwidth}\BODY%
\end{minipage}\end{figure}\else\ignorespaces\fi}
\makeatother