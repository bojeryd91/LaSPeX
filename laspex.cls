%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{laspex}[2020/11/16]
\LoadClass{report}

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
\RequirePackage{fancybox,framed}        % Used for nice-looking music box
\RequirePackage[swedish]{babel}
\RequirePackage[a4paper,        % Calls the geometry package with nice specifications.
 left=1.9in,
 top=1in,
 headsep=0.15in,
 bottom=2in,
 bmargin=1in,
 marginparwidth=1.1in,
 textwidth=4.65in,
 marginparsep=0.2in,            % Distance between character and line.
 footskip=30pt
]{geometry}
\DeclareOption{swedish}{%
\RequirePackage[swedish]{babel}
\RequirePackage[a4paper,        % Calls the geometry package with nice specifications.
 left=1.9in,
 top=1in,
 headsep=0.15in,
 bottom=2in,
 bmargin=1in,
 marginparwidth=1.1in,
 textwidth=4.65in,
 marginparsep=0.2in,            % Distance between character and line.
 footskip=30pt
]{geometry}}
% If book
\newif\if@book
\@bookfalse
\DeclareOption{book}{\@booktrue}
\ProcessOptions\relax

\setlength{\parindent}{0pt}     % Removes indents in the beginning of paragraphs
\pagestyle{fancy}               % Enable headings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Options
% Definiera option att ta bort scenhänvisningar
\newcommand\kommentarbool{1}
\DeclareOption{utan-kommentarer}{\renewcommand{\kommentarbool}{0}}
\DeclareOption{med-kommentarer}{\renewcommand{\kommentarbool}{1}}

% Definiera option att ta bort in- och utgångar samt teknikinstruktioner
\newcommand\teknikbool{1}
\DeclareOption{utan-teknik}{\renewcommand{\teknikbool}{0}}
\DeclareOption{med-teknik}{\renewcommand{\teknikbool}{1}}
\ProcessOptions\relax


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Counters, counters are set to zero upon creation
\newcounter{pagecounter_help}
\newcounter{pagecounter_help2}
\newcounter{aktcounter}
\newcounter{scencounter}
\setcounter{scencounter}{1}
\newcounter{subscencounter}
\newcounter{paragraphsOnPage}[page]     % set to zero each time page is updated
\newcounter{scenesOnPage}[paragraph]    % Try also scene

%%% Lengths
\newlength{\tmpl}                       % For subscenes
\newlength{\tmpM}                       % For subtitle music
\newlength{\tmpE}                       % For eller-title
\newlength{\musikboxl}
\setlength{\musikboxl}{\textwidth}
\addtolength{\musikboxl}{-10pt}

\newlength{\sepreplik}                  % Till repliker
\newlength{\vreplik}

\setlength{\vreplik}{0.3in}
\addtolength{\vreplik}{0.7in}
\setlength{\sepreplik}{\vreplik}
\addtolength{\sepreplik}{-0.1in}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Headers and footers
\renewcommand{\headrulewidth}{0pt}  % Removes header horizontal line.

%%% Common header and footer
\fancyhf{}
\rhead{%
    \footnotesize\textbf{\spextitel{}}%
    \settowidth{\tmpE}{\ellertitel{}}%
    % If tmpE is empty, do nothing, otherwise, print out eller-title
    \ifthenelse{\lengthtest{\tmpE=0pt}}{}%
    {\textrm{ -- eller }\bf{\ellertitel}}%
    \setcounter{pagecounter_help2}{\value{page}}%
    \addtocounter{pagecounter_help2}{-\value{pagecounter_help}}%
    \addtocounter{pagecounter_help2}{1}%
    \mbox{%
        \hspace{\marginparsep}\parbox[b]{20mm}%
        {\scenfont{Sida \arabic{aktcounter}.\arabic{pagecounter_help2}}}}%
    \hspace{-\marginparsep}\hspace{-20mm}%
}
\lhead{\footnotesize \bf{Akt \theaktcounter}}
\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}

%%% Front page header and footer
\fancypagestyle{framsida}{
    \def\SPeX{S\kern-.125em P\kern-.1667em \lower.5ex\hbox{E}\kern-.125em X}
    \def\LaSPeX{L\kern -.36em \raise.5ex\hbox{A}\kern -.15em\SPeX}
    \fancyhf{}
    \lfoot{\footnotesize Utskrift: \today, kl. \currenttime}
    \rfoot{\footnotesize \parbox[b]{65mm}{Skrivet i Jesper \LaSPeX-mall,\\ klart inspirerat utav Grodans \SPeX-mall}}
}

%%% Character page header and footer
\fancypagestyle{karaktarsida}{%
    \fancyhf{}%
    % Footer: print date
    \lfoot{\footnotesize Utskrift: \today, kl. \currenttime}%
    % Header: print title
    \rhead{\footnotesize\textbf{\spextitel{}}%
        \settowidth{\tmpE}{\ellertitel{}}%
        \ifthenelse{\lengthtest{\tmpE=0pt}}{\ignorespaces}%
        {\textrm{ -- eller }\bf{\ellertitel}}%
        % Print page number
        \mbox{\hspace{\marginparsep}\parbox[b]{20mm}{Sida \thepage}}%
        \hspace{-\marginparsep}\hspace{-20mm}%
    }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Framsidan
\newenvironment{framsida}{
    \newgeometry{left=1.5in,right=1.5in}
    \pagestyle{framsida}                    % Specifies header
    \centering
    {\Huge\spextitel}\                      % Title
    \settowidth{\tmpE}{\ellertitel{}}
    \ifthenelse{\lengthtest{\tmpE=0pt}}{}   % If tmpE is empty, do nothing. Else:
    {\bigskip                               % print out eller-title
    {\Large eller}\\
    \huge{\ellertitel}}
    \bigskip
}
{\clearpage\setcounter{page}{1}}            % new page

%%% Karaktärsidan/rollbeskrivning
\newenvironment{karaktarsida}{
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
        \parbox[b]{\sepreplik}{\raggedright\textbf{#1:}}}%
        \hspace{7pt}\ignorespaces}%
% Fortsätt replik
\newcommand{\forts}{\vspace{2mm}\Needspace{24pt}\ignorespaces}
% För att markera nya repliker
\newcommand{\nytt}[1]{#1\marginpar{\texttt{NYTT!!!}}}
% För att markera strukna repliker
\newcommand{\struket}[1]{\sout{#1}\marginpar{\normalsize{\texttt{Struket}}}}

%%% In- och utgång samt rekvisita
% Ingång
\newcommand{\ingang}[1]{\ifthenelse{\teknikbool=1}%
    {{\vspace{2mm}\Needspace{24pt}{\uwave{#1}}}
        \marginpar{\texttt{Ingång}}}{}}
% Utgång
\newcommand{\utgang}[1]{\ifthenelse{\teknikbool=1}%
    {{\vspace{2mm}\Needspace{24pt}{\uwave{#1}}}
        \marginpar{\texttt{Utgång}}}{}}
% Dekor, rekvisita och teknik
\newcommand{\dekor}[1]{\margintext{Dekor}{#1}}
\newcommand{\rekvisita}[1]{\margintext{Rekvisita}{#1}}
\newcommand{\teknik}[1]{\margintext{Teknik}{#1}}

% För beskrivning i sidfot till \dekor, \rekvisita, \teknik
\newcommand{\margintext}[2]{\ifthenelse{\teknikbool=1}%
    {\marginpar{\texttt{#1}}%
    \begingroup%
        \renewcommand\thefootnote{}\footnote{%
            \hspace{-0pt}%
            \mbox{%
                \hspace{-\vreplik}\parbox[b]{\sepreplik}%
                {\texttt{#1}}}%
            \hspace{7pt}#2%
        }%
        \addtocounter{footnote}{-1}
    \endgroup}
}

%%% Scenanvisningar och kommentarer
%%% Dessa kan gömmas med valet utan-kommentarer i manus preamble:
% Scenanvisning
\newcommand{\scenanvisning}[1]{\ifthenelse{\kommentarbool=1} {\vspace{2mm}\Needspace{24pt}
	{\textit{#1}}
}{\ignorespaces}}
% Fortsätt scenanvisning på samma rad
\newcommand{\scenanvisningforts}[1]{\ifthenelse{\kommentarbool=1}{\nopagebreak
	{\textit{#1}}
}{\ignorespaces}}
% Kommentarer
\newcommand{\kommentar}[1]{\ifthenelse{\kommentarbool=1}
	{\nopagebreak\small$\langle$\emph{#1}$\rangle$}
    {\ignorespaces}}                % If else, nothing (but ignore the space character)
% Hur
\newcommand{\hur}[1]{\kommentar{#1:}}
% Till:
\newcommand{\till}[1]{\kommentar{Till #1:}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Musikbox
%\musikbox{Titel}{Sångare}{Vad som händer}{Originaltitel}{Originalkompositör}
%                {valbar undertitel}
\newcommand{\musikbox}[6]{
    \medskip%
    \doublebox{%
    \vbox{%
        \hbox{\parbox[t]{0.8\musikboxl}{\small #2}}%
        \medskip%
        \hbox{\makebox[\musikboxl][c]{\Large\textbf{#1}}}%
        % Test if subtitle exists
        \settowidth{\tmpM}{#6}%
        % If tmpl is empty, use subscencounter
        \ifthenelse{\lengthtest{\tmpM=0pt}}{}%
        {\hbox{\makebox[\musikboxl][c]{%
            \textbf{#6}%
        }}}%
        \smallskip%
        \hbox{\makebox[\musikboxl][c]{(\emph{#4/#5})}}%
        \medskip%                       % Space between composer and what the song is about.
        \hbox{\parbox[t]{0.96\musikboxl}%
            {\textit{\small #3}}}%
    }}%
\medskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scenes and acts
\newcommand{\aktfont}[1]{{\Large\bf{#1}}}
\newcommand{\scenfont}[1]{\textbf{#1}}

% Act
\newcommand{\akt}[1]{%
    % To make line-breaking easier
    \obeylines              % A new line starts a new paragraph. Placed here
                            % because it doesn't work outside of a command
    \ifthenelse{\value{aktcounter} > 0}%
    {\newpage}{\ignorespaces}   % Create new page if not first act.
    \vspace{2mm}%
    \stepcounter{aktcounter}%
    \setcounter{pagecounter_help}{\value{page}}%
    \setcounter{pagecounter_help2}{1}%
    \hspace{-\vreplik}\if@book\hfil\aktfont{AKT \arabic{aktcounter}}\hfil\else%
    \parbox[b]{\sepreplik}%
    {\raggedright\aktfont{AKT \arabic{aktcounter}}}\hspace{7pt}\fi%
    \if@book\par\smallskip\hspace{-\vreplik}\hfill\aktfont{#1}\hfill\else\aktfont{#1}\fi%
    \value{scencounter} = 0% Reset scene counter
    \everypar{\hangindent1em\hangafter1}%
    \smallskip%
}

% Scene
\newcommand{\scen}[1]{%
    \Needspace{72pt}%
    % Increase scene counter and reset subscen counter
    \if@book\else\enlinje\fi%
    \stepcounter{scencounter}%
    \setcounter{subscencounter}{0}%
    \hspace{-\vreplik}\if@book \hrulefill\scenfont{SCEN \arabic{aktcounter}.\arabic{scencounter}}\hrulefill%
    \par\smallskip\hspace{-\vreplik}\hfill\scenfont{#1}\hfill%
    \else\parbox[b]{\sepreplik}%
    {\raggedright\scenfont{SCEN \arabic{aktcounter}.\arabic{scencounter}}}\hspace{7pt}\scenfont{#1}% Scene name
    \fi%
    \vspace{2mm}% Add extra vertical space after
}

% Subscene/subscen
% First, no-star version
\newcommand{\subscennostar}[2]{%
    \Needspace{72pt}\enlinje%
    % If this is the first subscen (within
    % a scene), increase scencounter
    \ifthenelse{\value{subscencounter} = 0}%
    {\stepcounter{scencounter}}{}%
    \stepcounter{subscencounter}%
    \mbox{%
        \hspace{-\vreplik}\parbox[b]{\sepreplik}{%
            \raggedright\scenfont{%
                SCEN \arabic{aktcounter}.\arabic{scencounter}%
                % Set tmpl to width of #2
                \settowidth{\tmpl}{#2}%
                % If tmpl is empty, use subscencounter
                \ifthenelse{\lengthtest{\tmpl=0pt}}%
                % linebreak is to place linebreak if too wide.
                {\alph{subscencounter}}{\linebreak[0]#2}%
            }%
        }%
    }\hspace{7pt}%
    \scenfont{#1}%
    \vspace{2mm}%
}
% Starred version
\newcommand{\subscenstar}[2]{
    % If starred version, increment scencounter and reset subscencounter.
    \setcounter{subscencounter}{0}%
    \subscennostar{#1}{#2}%
}
% Actually called command
\makeatletter
\newcommand\subscen{
\@ifstar\subscenstar\subscennostar}
\makeatother

% Definierar en linje, används av \scen och \subscen
\newcommand*{\enlinje}{
    \vspace{2mm}
    \cleaders\vbox to 0.4pt{\hrulefill}
    \vskip0.4pt
    \vspace{1mm}
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
