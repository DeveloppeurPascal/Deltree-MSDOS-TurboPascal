program delete_tree;
{
Auteur: Pr‚martin Patrick
Date: 30/08/1991.
      31/08/1991.
      01/09/1991.
      10/09/1991.
Langage: Turbo Pascal 6.0
But: Suppression d'une arborescence complŠte.
}
uses
    crt,
    dos,
    olf_software,
    u_code_clavier,
    u_fdtree,
    u_m_util,
    u_parametre;

const
     num_vers : string [3] = '1.0';
     dat_vers : string [10] = '09/10/1991';

type
    o_del = object (o_fdtree)
                   function treat_file (f : searchrec) : boolean; virtual;
                   function treat_directory (d : searchrec) : boolean; virtual;
                   function stop_run : boolean; virtual;
    end;

function o_del.treat_file (f : searchrec) : boolean;
var
   fich : file;
begin
     write (f.name : 16);
     assign (fich, f.name);
     {$i-}
     erase (fich);
     {$i+}
     treat_file := (ioresult = 0);
end; { O_Del.Treat_File }

function o_del.treat_directory (d : searchrec) : boolean;
var
   path : string;
begin
     getdir (0, path);
     if ((d.name = '.') or (d.name = '..') or (path [pred (length (path))] = ':'))
     then
         treat_directory := true
     else
         begin
              writeln;
              writeln ('Erase: ', path);
              chdir ('..');
              {$i-}
              rmdir (d.name);
              {$i+}
              treat_directory := (ioresult = 0);
         end;
     {endif}
end; { O_Del.Treat_Directory }

function o_del.stop_run : boolean;
begin
     stop_run := (readkey in [' ', touche_escape]);
end; { O_Del.Stop_Run }

var
   old_dir : string;
   prog : o_del;
   i : integer;

begin
     init_licence ('DELT');
     init_olf_message (mess_careware);
     init_ligne_olf_software ('Delete Tree '+num_vers, #155' PrePat '+dat_vers);
     i := 1;
     if ((param_del ('/H')) or (param_del ('/?')))
     then
         begin
              writeln ('Syntax: ');
              writeln ('        deltree Path_Name [/h|/?]');
              writeln;
              writeln ('This program erase all files and directories in "Path_Name".');
              writeln ('If you confirm that you want to del "Path_Name", you can abort');
              writeln ('by pressing ESC or SPACE.');
         end
     else
         if (paramcount > 0)
         then
             while not (i > paramcount) do
                   begin
                        prog.init;
                        old_dir := fexpand (paramstr (i));
                        prog.set_start_directory (old_dir);
                        prog.set_fdtree_sens (prefixe);
                        if (confirm ('Do you want to erase '+old_dir+' ?'))
                        then
                            prog.run;
                        {endif}
                        prog.done;
                        writeln;
                        inc (i);
                   end;
             {endwhile}
         {endif}
     {endif}
end. { DelTree }
