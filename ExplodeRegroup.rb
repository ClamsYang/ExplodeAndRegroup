module ExplodeRegroup
  def self.main
    mod = Sketchup.active_model
    sel = mod.selection

    Sketchup.active_model.start_operation("炸开重组", true)
    if sel.empty?
      UI.messagebox ("蛤蜊提醒:清选择需要炸开重组的物体")
      return
    end

    p sel.to_a
    sel.to_a.each { |e|
      if (e.is_a? Sketchup::ComponentInstance) || (e.is_a? Sketchup::Group)
        explode_and_regroup(e)
      end
    }
    Sketchup.set_status_text "蛤蜊提示：已炸开重组", SB_VCB_LABEL
    Sketchup.active_model.commit_operation
  end #main

  def self.explode_and_regroup(comp)
    name = comp.definition.name
    arr = comp.explode
    ents = arr.select { |e| (e.is_a? Sketchup::Face) || (e.is_a? Sketchup::Edge) || (e.is_a? Sketchup::ComponentInstance) || (e.is_a? Sketchup::Group) }
    group = Sketchup.active_model.entities.add_group ents
    group.name = "re#{name}"
  end #explode_and_regroup

  def self.create_toolbar
    menu = UI.menu("Extensions")
    toolbar = UI::Toolbar.new "炸开重组"
    submenu = menu.add_submenu("炸开重组")
    submenu.add_item("炸开重组") { ExplodeRegroup.main }

    cmd = UI::Command.new("炸开重组") { ExplodeRegroup.main }
    cmd.small_icon = cmd.large_icon = "ExplodeRegroup/explode_and_regroup.png"
    cmd.tooltip = "蛤蜊制作"
    cmd.status_bar_text = "version 1.0"

    toolbar.add_item(cmd)
    toolbar.show
  end

  unless file_loaded?(__FILE__)
    create_toolbar
    file_loaded(__FILE__)
  end
end #module
