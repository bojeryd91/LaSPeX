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

\def\actprint{Act}
\def\sceneprint{Scene}
\def\pageprint{Page}

\newif\if@swedish
\newif\if@comments
\newif\if@book
\newif\if@inspicio % Bool for stage mananger
\newif\if@scenery

\@bookfalse
\@swedishfalse
\@commentstrue
\@inspiciotrue
\@scenerytrue

% If option on
\DeclareOption{swedish}{\@swedishtrue}
\DeclareOption{book}{\@booktrue}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Options
% Definiera option att ta bort scenhänvisningar
\DeclareOption{utan-kommentarer}{\@commentsfalse}
\DeclareOption{med-kommentarer}{\@commentstrue}

% Definiera option att ta bort in- och utgångar samt teknikinstruktioner
\newcommand\teknikbool{1}
\DeclareOption{utan-teknik}{\renewcommand{\teknikbool}{1}\@sceneryfalse}
\DeclareOption{med-teknik}{\renewcommand{\teknikbool}{1}\@scenerytrue}


\ProcessOptions\relax

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

%%% Lengths
\newlength{\tmpl}                       % For subscenes
\newlength{\tmpM}                       % For subtitle music
\newlength{\tmpE}                       % For eller-title
\newlength{\musicboxl}
\setlength{\musicboxl}{\textwidth}
\addtolength{\musicboxl}{-10pt}

\newlength{\sepreplik}                  % Till repliker
\newlength{\vreplik}

\setlength{\vreplik}{0.3in}
\addtolength{\vreplik}{0.7in}
\setlength{\sepreplik}{\vreplik}
\addtolength{\sepreplik}{-0.1in}
\if@book\addtolength{\musicboxl}{\vreplik}\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Language selection
\if@swedish%
\def\actprint{Akt}%
\def\sceneprint{Scen}%
\def\pageprint{Sida}%
\RequirePackage[swedish]{babel}\fi

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
        {\scenfont{\pageprint{} \arabic{actcounter}.\arabic{pagecounter_help2}}}}%
    \hspace{-\marginparsep}\hspace{-20mm}%
}
\lhead{\footnotesize \bf{\actprint{} \theactcounter}}
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
\newcommand{\stageInstruction}[2]{%
        \if@scenery\vspace{2mm}\Needspace{24pt}{\uwave{#1}}%
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
\newcommand{\scenanvisning}[1]{%
    \if@comments%
        \vspace{2mm}\Needspace{24pt}
    	{\textit{#1}}%
	\else\ignorespaces\fi}
% Fortsätt scenanvisning på samma rad
\newcommand{\scenanvisningforts}[1]{%
    \if@comments\nopagebreak{\textit{#1}}\else\ignorespaces\fi}
% Kommentarer
\newcommand{\kommentar}[1]{%
    \if@comments\nopagebreak\small$\langle$\emph{#1}$\rangle$%
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
        \hbox{\makebox[\musicboxl][c]{\Large\textbf{#1}}}%
        \settowidth{\tmpM}{#6}% Test if subtitle exists
        \ifnum\tmpM>0\smallskip\hbox{\makebox[\musicboxl][c]{\textbf{#6}}}\fi
        \smallskip%
        \hbox{\makebox[\musicboxl][c]{(\emph{#4/#5})}}%
        \medskip%
        \hbox{\parbox[t]{0.96\musicboxl}%
            {\textit{\small #3}}}%
    }}%
\medskip}
\newcommand{\musikbox}[6]{\musicbox{#1}{#2}{#3}{#4}{#5}{#6}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scenes and acts
\newcommand{\actfont}[1]{{\Large\bf{#1}}}
\newcommand{\scenfont}[1]{\textbf{#1}}

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
\newcommand{\scen}[1]{%
    \Needspace{72pt}%
    % Increase scene counter and reset subscen counter
    \if@book\else\enlinje\fi%
    \stepcounter{scencounter}%
    \setcounter{subscenecounter}{0}%
    \hspace{-\vreplik}%
    \if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern2pt%
        \scenfont{\uppercase{\sceneprint} \arabic{actcounter}:\arabic{scencounter}}%
        \kern2pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{#1}\hfill%
    \else\parbox[b]{\sepreplik}%
    {\raggedright\scenfont{\uppercase{\sceneprint} \arabic{actcounter}.\arabic{scencounter}}}\hspace{7pt}\scenfont{#1}% Scene name
    \fi%
    \vspace{2mm}% Add extra vertical space after
}

% Subscene/subscen
% First, no-star version
\newcommand{\subscennostar}[2]{%
    \if@book\else\Needspace{72pt}\enlinje\fi%
    % If this is the first subscen (within
    % a scene), increase scencounter
    \ifthenelse{\value{subscenecounter} = 0}%
    {\stepcounter{scencounter}}{}%
    \stepcounter{subscenecounter}%
    \hspace{-\vreplik}%
    \if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern2pt%
        \scenfont{\uppercase{\sceneprint} \arabic{actcounter}:\arabic{scencounter}\alph{subscenecounter}}%
        \kern2pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{#1}\hfill%
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
    \vspace{2mm}%
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
